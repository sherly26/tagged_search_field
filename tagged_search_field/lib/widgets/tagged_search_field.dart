import 'package:flutter/material.dart';
import 'package:tagged_search_field/models/tagged_search_field.model.dart';

class TaggedSearchField extends StatefulWidget {
  final TextEditingController searchBarController;
  final Function(String) onSearchTextChanged;
  final Function onSelected;
  final String searchBarTitle;
  final List<TaggedSearchFieldModel> selected;
  final List<TaggedSearchFieldModel> filtered;
  final List<TaggedSearchFieldModel> all;

  const TaggedSearchField({
    required Key key,
    required this.searchBarTitle,
    required this.searchBarController,
    required this.onSearchTextChanged,
    required this.onSelected,
    required this.selected,
    required this.filtered,
    required this.all,
  }) : super(key: key);

  @override
  _TaggedSearchFieldState createState() => _TaggedSearchFieldState();
}

class _TaggedSearchFieldState extends State<TaggedSearchField> {
  bool isSearching() => widget.searchBarController.text.isNotEmpty;

  @override
  void initState() {
    widget.searchBarController
        .addListener(() => setState(() => widget.searchBarController.text));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
        width: double.infinity,
        child: Column(
          children: [
            Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: _buildSearchBar()),
            if (isSearching())
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.8,
                    alignment: Alignment.topCenter,
                    child: _buildResultsList()),
              ),
          ],
        ));
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            cursorWidth: 3.0,
            controller: widget.searchBarController,
            keyboardType: TextInputType.text,
            onChanged: widget.onSearchTextChanged,
            decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                hintText: widget.searchBarTitle,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ))),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        //Tags will be built based on the items of selected list.
        if (widget.selected.isNotEmpty)
          SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: _buildFieldTags()),
        if (widget.searchBarController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
                onTap: () => widget.searchBarController.clear(),
                child: Icon(Icons.close, color: Colors.grey[500], size: 25)),
          )
      ],
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount:
          widget.filtered.isEmpty ? widget.all.length : widget.filtered.length,
      itemBuilder: (context, int index) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              border: const Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5))),
          child: ListTile(
            onTap: () async {
              //Widget automatically adds to selected list what you tap on.
              if (widget.filtered.isNotEmpty) {
                if (!widget.selected
                    .contains(widget.filtered.elementAt(index))) {
                  widget.selected.add(widget.filtered.elementAt(index));
                }
                await widget.onSelected();
              }

              setState(() => widget.searchBarController.clear());
            },
            title: Text(
                widget.filtered.isEmpty
                    ? widget.all.elementAt(index).name
                    : widget.filtered.elementAt(index).name,
                style: const TextStyle(fontSize: 15.0)),
          ),
        );
      },
    );
  }

  Widget _buildFieldTags() {
    const TextStyle textStyle = TextStyle(color: Colors.white);
    return ListView(scrollDirection: Axis.horizontal, children: [
      ...widget.selected.map((tag) {
        final Size size = (TextPainter(
                text: TextSpan(text: tag.name, style: textStyle),
                maxLines: 1,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textDirection: TextDirection.ltr)
              ..layout())
            .size;

        return Wrap(children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            width: size.width + 55,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.greenAccent[400],
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                    child: Text(tag.name,
                        style: textStyle,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true)),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child:
                        const Icon(Icons.close, size: 20, color: Colors.white),
                    onTap: () {
                      final foundItem = widget.selected
                          .where((element) => element.name == tag.name)
                          .first;
                      setState(() {
                        widget.selected.remove(foundItem);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ]);
      })
    ]);
  }
}
