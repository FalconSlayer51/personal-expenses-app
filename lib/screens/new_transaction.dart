import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  const NewTransaction({Key? key, required this.addtx}) : super(key: key);
  final Function addtx;
  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? selectedDate;

  void _submitData() {
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
      return;
    }
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('${enteredTitle}' + '${enteredAmount}')),
    // );

    widget.addtx(
      enteredTitle,
      enteredAmount,
      selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date == null) {
        return;
      }
      setState(() {
        selectedDate = date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Color(0xfffdfdfd),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(35),
            topLeft: Radius.circular(35),
          )),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        TextField(
          decoration: InputDecoration(labelText: 'title'),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          controller: titleController,
          onSubmitted: (_) => _submitData(),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'amount'),
          keyboardType: TextInputType.number,
          controller: amountController,
          onSubmitted: (_) => _submitData(),
        ),
        const SizedBox(
          height: 20,
        ),
        selectedDate == null
            ? Text('')
            : Text('${DateFormat.yMMMEd().format(selectedDate!)}'),
        const SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: _datePicker,
          child: const Text('Choose Date'),
        ),
        const SizedBox(
          height: 20,
        ),
        MaterialButton(
          onPressed: _submitData,
          color: Colors.blue,
          child: const Text(
            "Add Transaction",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ]),
    );
  }
}
