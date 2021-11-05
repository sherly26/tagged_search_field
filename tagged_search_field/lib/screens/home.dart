import 'package:flutter/material.dart';
import 'package:tagged_search_field/models/tagged_search_field.model.dart';
import 'package:tagged_search_field/resources/state_list.dart';
import 'package:tagged_search_field/widgets/tagged_search_field.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchBarController = TextEditingController();
  List<TaggedSearchFieldModel> selectedStates = [];
  List<TaggedSearchFieldModel> filteredStates = [];
  List<TaggedSearchFieldModel> allStates = StateList()
      .getStatesList()
      .map((state) => TaggedSearchFieldModel(state))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)), body: _buildBody());
  }

  Widget _buildBody() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: TaggedSearchField(
          key: const ValueKey('key'),
          searchBarTitle: 'Search States',
          searchBarController: _searchBarController,
          onSearchTextChanged: onSearchTextChanged,
          onSelected: onSelected,
          selected: selectedStates,
          filtered: filteredStates,
          all: allStates),
    );
  }

  void onSearchTextChanged(String text) {
    filteredStates.clear();
    setState(() {
      if (text.isEmpty) {
        return;
      }
      for (TaggedSearchFieldModel _state in allStates) {
        if (_state.name
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .toLowerCase()
            .contains(text)) filteredStates.add(_state);
      }
    });
  }

  void onSelected() {
    print('New tag has been selected.');
  }
}
