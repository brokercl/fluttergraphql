class QueryMutation {
  String addUser(int id, String user, String email) {
    return """
      mutation{
          addUser(id: "$id", user: "$user", email: "$email"){
            id
            user
            email
          }
      }
    """;
  }

  String getUsers(){
    return """ 
      {
        users{
          id
          user
          email
        }
      }
    """;
  }

  String deleteUser(id){
    return """
      mutation{
        deleteUser(id: "$id"){
          id
        }
      } 
    """;
  }

  String editUser(int id, String user, String email){
    return """
      mutation{
          editUser(id: "$id", user: "$user", email: "$email"){
            user
            email
          }
      }    
     """;
  }
}