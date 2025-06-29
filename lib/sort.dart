import 'package:push_swap_it/model.dart';

void sortList(List<Node> list)
{
  final List<Node> newList = [];

  for (var i = 0; i < list.length; i++){
    newList.add(list[i]);
  }

  for (var i = 0; i < list.length - 1; i++){
    for (var j = i + 1; j < list.length; j++){
      if (newList[i].value - newList[j].value > 0){
        final node = newList[i];
        newList[i] = newList[j];
        newList[j] = node;
        final order = newList[i].order;
        newList[i].order = newList[j].order;
        newList[j].order = order;
      }
    }
  }
}