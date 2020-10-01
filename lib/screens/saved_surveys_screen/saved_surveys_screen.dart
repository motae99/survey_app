import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/local_database/moor_database.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:survey_app/screens/saved_surveys_screen/survey_description_screen.dart';

class SavedSurveysScreen extends StatefulWidget {
  @override
  _SavedSurveysScreenState createState() => _SavedSurveysScreenState();
}

class _SavedSurveysScreenState extends State<SavedSurveysScreen> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:isLoading==false? Container(
          child: FutureBuilder(
            future: Provider.of<AppDatabase>(context).getAllSurveys(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if(snapshot.hasData){
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                      ),
                    );
                  } else {
                    final response = snapshot.data;

                    return _buildList(context, response);

//
//
                  }
                }else{
                  return Center(
                    child: Text("No Surveys Saved",style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    ),).tr(context: context),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ):Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, var survey) {
    // var convertData=DataModel.fromJson(survey);
    // print(convertData);

    return ListView.builder(
        itemCount: survey.length,
        itemBuilder: (context, i) {
          var data = survey[i].surveys;
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SurveyDescriptionScreen(
                            data: data,
                          )));
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              data.name,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "Created on  ".tr(),
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: data.createdAt,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black38,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                          ]),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1, color: Colors.black54)),
                            child: Icon(
                              Icons.edit,
                              color: Colors.black54,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading=true;
                            });

                            final database =  Provider.of<AppDatabase>(
                                context,
                                listen: false);

                            var response =await database.deleteSurveys(survey[i]);

                            print("response !!!!!!!!!!!!!!");
                            print(response);

                            setState(() {
                              isLoading=false ;
                            });
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1, color: Colors.black54)),
                              child: Icon(
                                Icons.delete,
                                color: Colors.black54,
                              )),
                        ),
                      ],
                    )
                  ],
                )),
          );
        });
  }
}
