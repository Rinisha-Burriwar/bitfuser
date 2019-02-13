import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' as DragStartBehavior;
// https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/text_form_field_demo.dart
// https://flutterbyexample.com/forms-1-user-input/
class MemoData {
  String title = '';
  String input = '';
  String password = '';

}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          //dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText ? 'show password' : 'hide password',
          ),
        ),
      ),
    );
  }
}

// Create memo form
class MemoForm extends StatefulWidget{
  const MemoForm({ Key key }) : super(key: key);
  @override
  MemoFormState createState() => MemoFormState();
  //static const String routeName = '/material/text-form-field';
}

class MemoFormState extends State<MemoForm>{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Init memo
  MemoData memoData = MemoData();

  // IF any error show in snack bar
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  bool _autovalidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = GlobalKey<FormFieldState<String>>();

  // Handle / validate user submit form
  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showInSnackBar('${memoData.title}\'s phone number is ${memoData.password}');
    }
  }

  // Validate regex string extra feature
  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Name is required.';
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  // Validate password submitted in form
  String _validatePassword(String value) {
    _formWasEdited = true;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    if (passwordField.value != value)
      return 'The passwords don\'t match';
    return null;
  }

  // Warn user if when leaving back to screen
  Future<bool> _warnUserAboutInvalidData() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formWasEdited || form.validate())
      return true;

    // Warn user if when leaving back to screen
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('This form has errors'),
          content: const Text('Really leave this form?'),
          actions: <Widget> [
            FlatButton(
              child: const Text('YES'),
              onPressed: () { Navigator.of(context).pop(true); },
            ),
            FlatButton(
              child: const Text('NO'),
              onPressed: () { Navigator.of(context).pop(false); },
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawerDragStartBehavior: DragStartBehavior.down,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Text fields'),
        //actions: <Widget>[MaterialDemoDocumentationButton(TextFormFieldDemo.routeName)],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          onWillPop: _warnUserAboutInvalidData,
          child: SingleChildScrollView(
            //dragStartBehavior: DragStartBehavior.down,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: <Widget>[
                   const SizedBox(height: 24.0),
                   TextFormField(
                     keyboardType: TextInputType.number,
                     decoration: const InputDecoration(
                         border: OutlineInputBorder(),
                         labelText: 'Salary',
                         prefixText: '\$',
                         suffixText: 'USD',
                         suffixStyle: TextStyle(color: Colors.green)
                     ),
                     maxLines: 1,
                   ),
                   const SizedBox(height: 24.0),
                   TextFormField(
                     decoration: const InputDecoration(
                       border: OutlineInputBorder(),
                       hintText: 'Tell us about yourself (e.g., write down what you do or what hobbies you have)',
                       helperText: 'Keep it short, this is just a demo.',
                       labelText: 'Life story',
                     ),
                     maxLines: 3,
                   ),
                   const SizedBox(height: 24.0),
                   PasswordField(
                     fieldKey: _passwordFieldKey,
                     helperText: 'No more than 8 characters.',
                     labelText: 'Password *',
                     onFieldSubmitted: (String value) {
                       setState(() {
                         memoData.password = value;
                       });
                     },
                   ),
                   const SizedBox(height: 24.0),
                   TextFormField(
                     enabled: memoData.password != null && memoData.password.isNotEmpty,
                     decoration: const InputDecoration(
                       border: UnderlineInputBorder(),
                       filled: true,
                       labelText: 'Re-type password',
                     ),
                     maxLength: 8,
                     obscureText: true,
                     validator: _validatePassword,
                   ),
                   const SizedBox(height: 24.0),
                   Center(
                     child: RaisedButton(
                       child: const Text('Save'),
                       onPressed: _handleSubmitted,
                     ),
                   ),
                   const SizedBox(height: 24.0),
                   Text(
                       '* we do not store you password',
                       style: Theme.of(context).textTheme.caption
                   ),
                   const SizedBox(height: 24.0),
                 ],
             ),
          ),
        ),
    ),

    );
  }
}




