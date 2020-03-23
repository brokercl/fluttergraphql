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
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
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
      txtUser.text = user.getUser();
      txtEmail.text = user.getEmail();
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
                  child: TextField(
                    maxLength: 5,
                    controller: txtId,
                    enabled: this.isAdd,
                    decoration: InputDecoration(
                      icon: Icon(Icons.perm_identity),
                      labelText: "ID",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 80.0),
                  child: TextField(
                    maxLength: 40,
                    controller: txtUser,
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_format),
                      labelText: "User",
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
            if (txtId.text.isNotEmpty &&
                txtUser.text.isNotEmpty &&
                txtEmail.text.isNotEmpty )
              if (this.isAdd) {
                GraphQLClient _client = graphQLConfiguration.clientToQuery();
                QueryResult result = await _client.mutate(
                  MutationOptions(
                    document: addMutation.addUser(
                      txtId.text,
                      txtUser.text,
                      txtEmail.text,
                    ),
                  ),
                );
                if (!result.hasException) {
                  txtId.clear();
                  txtUser.clear();
                  txtEmail.clear();
                  Navigator.of(context).pop();
                }
              } else {
                GraphQLClient _client = graphQLConfiguration.clientToQuery();
                QueryResult result = await _client.mutate(
                  MutationOptions(
                    document: addMutation.editUser(
                      txtId.text,
                      txtUser.text,
                      txtEmail.text,
                    ),
                  ),
                );
                if (!result.hasException) {
                  txtId.clear();
                  txtUser.clear();
                  txtEmail.clear();
                  Navigator.of(context).pop();
                }
              }
          },
        )
      ],
    );
  }
}