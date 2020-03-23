import "package:flutter/material.dart";
import "alertDialogs.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import "user.dart";
import "graphqlConf.dart";
import "queryMutation.dart";

class Principal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Principal();
}

class _Principal extends State<Principal> {
  List<User> listUser = List<User>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  void fillList() async {
    QueryMutation queryMutation = QueryMutation();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        document: queryMutation.getUsers(),
      ),
    );
    if (!result.hasException) {
      for (var i = 0; i < result.data["users"].length; i++) {
        setState(() {
          listUser.add(
            User(
              result.data["users"][i]["id"],
              result.data["users"][i]["user"],
              result.data["users"][i]["email"],
            ),
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fillList();
  }

  void _addUser(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        AlertDialogWindow alertDialogWindow =
        new AlertDialogWindow(isAdd: true);
        return alertDialogWindow;
      },
    ).whenComplete(() {
      listUser.clear();
      fillList();
    });
  }

  void _editDeleteUser(context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        AlertDialogWindow alertDialogWindow =
        new AlertDialogWindow(isAdd: false, user: user);
        return alertDialogWindow;
      },
    ).whenComplete(() {
      listUser.clear();
      fillList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Example"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () => _addUser(context),
            tooltip: "Insert new user",
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "User",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50.0),
            child: ListView.builder(
              itemCount: listUser.length,
              itemBuilder: (context, index) {
                return ListTile(
                  selected: listUser == null ? false : true,
                  title: Text(
                    "${listUser[index].getUser()}",
                  ),
                  onTap: () {
                    _editDeleteUser(context, listUser[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}