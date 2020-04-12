import "package:flutter/material.dart";
import "graphqlConf.dart";
import "queryMutation.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import "user.dart";

class AlertDialogWindow extends StatefulWidget {
  final User user;
  final bool isAdd;

  AlertDialogWindow({Key key, this.user, this.isAdd}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _AlertDialogWindow(this.user, this.isAdd);
}

class _AlertDialogWindow extends State<AlertDialogWindow> {
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();

  final User user;
  final bool isAdd;

  _AlertDialogWindow(this.user, this.isAdd);

  @override
  void initState() {
    super.initState();
    if (!this.isAdd) {
      txtId.text = user.getId();
      txtName.text = user.getName();
      txtEmail.text = user.getEmail();
      txtPassword.text = user.getPassword();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text(this.isAdd ? "Add" : "Edit or Delete"),
      content: Container(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 80.0),
                  child: TextField(
                    maxLength: 40,
                    controller: txtName,
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_format),
                      labelText: "Name",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 160.0),
                  child: TextField(
                    maxLength: 40,
                    controller: txtEmail,
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_rotate_vertical),
                      labelText: "Email",
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(top: 240.0),
                  child: TextField(
                    maxLength: 40,
                    controller: txtPassword,
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_rotate_vertical),
                      labelText: "Password",
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Close"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        !this.isAdd
            ? FlatButton(
          child: Text("Delete"),
          onPressed: () async {
            GraphQLClient _client = graphQLConfiguration.clientToQuery();
            QueryResult result = await _client.mutate(
              MutationOptions(
                document: addMutation.deleteUser(txtId.text),
              ),
            );
            if (!result.hasException) Navigator.of(context).pop();
          },
        )
            : null,
        FlatButton(
          child: Text(this.isAdd ? "Add" : "Edit"),
          onPressed: () async {
            if (txtName.text.isNotEmpty &&
                txtEmail.text.isNotEmpty &&
                txtPassword.text.isNotEmpty
            )
              if (this.isAdd) {
                GraphQLClient _client = graphQLConfiguration.clientToQuery();
                QueryResult result = await _client.mutate(
                  MutationOptions(
                    document: addMutation.createUser(
                      txtName.text,
                      txtEmail.text,
                      txtPassword.text
                    ),
                  ),
                );
                if (!result.hasException) {
                  txtId.clear();
                  txtName.clear();
                  txtEmail.clear();
                  txtPassword.clear();
                  Navigator.of(context).pop();
                }
              } else {
                GraphQLClient _client = graphQLConfiguration.clientToQuery();
                QueryResult result = await _client.mutate(
                  MutationOptions(
                    document: addMutation.updateUser(
                      txtId.text,
                      txtName.text,
                      txtEmail.text,
                      txtPassword.text
                    ),
                  ),
                );
                if (!result.hasException) {
                  txtId.clear();
                  txtName.clear();
                  txtEmail.clear();
                  txtPassword.clear();
                  Navigator.of(context).pop();
                }
              }
          },
        )
      ],
    );
  }
}