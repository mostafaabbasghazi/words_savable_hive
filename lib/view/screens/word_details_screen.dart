import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/controllers/read_data_cubit/read_data_cubit.dart';
import '/controllers/read_data_cubit/read_data_cubit_states.dart';
import '/controllers/write_data_cubit/write_data_cubit.dart';
import '/model/word_model.dart';
import '/view/widgets/exception_widget.dart';
import '/view/widgets/lodaing_widget.dart';
import '/view/widgets/update_word_button.dart';
import '/view/widgets/update_word_dialog.dart';
import '/view/widgets/word_info_widget.dart';

class WordDetailsScreen extends StatefulWidget {
  const WordDetailsScreen({super.key,required this.wordModel});

  final WordModel wordModel;

  @override
  State<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends State<WordDetailsScreen> {

  late WordModel _wordModel;

  @override
  void initState() {
    super.initState();
    _wordModel=widget.wordModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(context),
      body: BlocBuilder<ReadDataCubit,ReadDataCubitStates>(
        builder: (context, state) {
          if(state is ReadDataCubitSuccessState){
            int index= state.words.indexWhere((element) => element.indexAtDatabase==_wordModel.indexAtDatabase);
            _wordModel=state.words[index];
            return _getSuccessBody(context);
          }
          if(state is ReadDataCubitFailedState){
            return ExceptionWidget(iconData: Icons.error, message: state.message);
          }
          return const LoadingWidget();
        },
      ),
    );
  }

  ListView _getSuccessBody(BuildContext context) {
    return ListView(
      padding:const EdgeInsets.symmetric(horizontal: 10),
      children: [
        _getLabelText("Word"),
         SizedBox(height: 5.h,),
        WordInfoWidget(
          color:Color( _wordModel.colorCode),
          text: _wordModel.text,
          isArabic: _wordModel.isArabic,
        ),
         SizedBox(height: 20.h,),
        Row(
          children: [
            _getLabelText("Similar Words"),
            const Spacer(),
            UpdateWordButton(
              color: Color(_wordModel.colorCode),
              onTap: () => showDialog(context: context, builder: ((context) => UpdateWordDialog(
                isExample: false,
                colorCode: _wordModel.colorCode,
                indexAtDatabase: _wordModel.indexAtDatabase,
                ))),
            ),
          ],
        ),
         SizedBox(height: 10.h,),
        for(int i=0;i<_wordModel.arabicSimilarWords.length;i++)
        WordInfoWidget(
          color: Color(_wordModel.colorCode), 
          isArabic: true, 
          text: _wordModel.arabicSimilarWords[i],
          onPressed: ()=>_deleteArabicSimilarWord(i),
        ),
        for(int i=0;i<_wordModel.englishSimilarWords.length;i++)
        WordInfoWidget(
          color: Color(_wordModel.colorCode), 
          isArabic: false, 
          text: _wordModel.englishSimilarWords[i],
          onPressed: ()=>_deleteEnglishSimilarWord(i),
        ),

         SizedBox(height: 20.h,),
        Row(
          children: [
            _getLabelText("Examples"),
            const Spacer(),
            UpdateWordButton(
              color: Color(_wordModel.colorCode),
              onTap: () => showDialog(context: context, builder: ((context) =>UpdateWordDialog(
                isExample: true,
                colorCode: _wordModel.colorCode,
                indexAtDatabase: _wordModel.indexAtDatabase,
                ))),
            ),
          ],
        ),
         SizedBox(height: 10.h,),
        for(int i=0;i<_wordModel.arabicExamples.length;i++)
        WordInfoWidget(
          color: Color(_wordModel.colorCode), 
          isArabic: true, 
          text: _wordModel.arabicExamples[i],
          onPressed:()=> _deleteArabicExample(i),
        ),

        for(int i=0;i<_wordModel.englishExamples.length;i++)
        WordInfoWidget(
          color: Color(_wordModel.colorCode), 
          isArabic: false, 
          text: _wordModel.englishExamples[i],
          onPressed: ()=>_deleteEnglishExample(i),
        ),

      ],
    );
  }

  void _deleteEnglishExample(int index) {
    WriteDataCubit.get(context).deleteExample(
      _wordModel.indexAtDatabase, 
      index, 
      false,
    );  
    ReadDataCubit.get(context).getWords();      
  }

  void _deleteArabicExample(int index) {
    WriteDataCubit.get(context).deleteExample(
      _wordModel.indexAtDatabase, 
      index, 
      true,
    ); 
    ReadDataCubit.get(context).getWords();

  }

  void _deleteEnglishSimilarWord(int index) {
    WriteDataCubit.get(context).deleteSimilarWord(
      _wordModel.indexAtDatabase, 
      index, 
      false,
    );   
    ReadDataCubit.get(context).getWords();
  }

  void _deleteArabicSimilarWord(int index){
    WriteDataCubit.get(context).deleteSimilarWord(
      _wordModel.indexAtDatabase, 
      index, 
      true,
    );
    ReadDataCubit.get(context).getWords();
  }

  Widget _getLabelText(String label)=>Text(
    label,
    style: TextStyle(
      color: Color(_wordModel.colorCode),
      fontSize: 21.sp,
      fontWeight: FontWeight.bold,
    ),
  );

  AppBar _getAppBar(context) => AppBar(
    foregroundColor: Color(_wordModel.colorCode),
    title: Text(
      "Word Details",
      style: TextStyle(
        color:Color( _wordModel.colorCode),
      ),
    ),
    actions: [
      IconButton(
        onPressed: ()=>_deleteWord(context), 
        icon:const Icon(Icons.delete,),
      )
    ],
  );

  void _deleteWord(BuildContext context){
    WriteDataCubit.get(context).deleteWord(_wordModel.indexAtDatabase);
    Navigator.pop(context);
  }
}