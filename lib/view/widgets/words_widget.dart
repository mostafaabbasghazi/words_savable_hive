import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/controllers/read_data_cubit/read_data_cubit.dart';
import '/controllers/read_data_cubit/read_data_cubit_states.dart';
import '/model/word_model.dart';
import '/view/widgets/exception_widget.dart';
import '/view/widgets/lodaing_widget.dart';
import '/view/widgets/word_item_widget.dart';

class WordsWidget extends StatelessWidget {
  const WordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadDataCubit,ReadDataCubitStates>(
      builder: ((context, state) {
        if(state is ReadDataCubitSuccessState){
          if(state.words.isEmpty){
            return _getEmptyWordsWigdet();
          }
          return _getWordsWidget(state.words);
        }else if(state is ReadDataCubitFailedState){
          return _getFailedWidget(state.message);
        }else{
          return _getLoadingWidget();
        }
      }),
    );
  }

  Widget _getWordsWidget(List<WordModel>words){
    return GridView.builder(
      itemCount: words.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
        childAspectRatio: 2/1.5,
      ), 
      itemBuilder: ((context, index) {
        return WordItemWidget(wordModel: words[index]);
      }),
    );
  }

  Widget _getEmptyWordsWigdet(){
    return const ExceptionWidget(
      iconData: Icons.list_rounded,
      message: "Empty Words List",
    );
  }

  Widget _getFailedWidget(String message){
    return  ExceptionWidget(
      iconData: Icons.error,
      message: message,
    );
  }

  Widget _getLoadingWidget(){
    return const LoadingWidget();
  }


}