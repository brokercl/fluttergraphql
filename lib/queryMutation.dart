class QueryMutation {
  String createUser(String name, String email, String password) {
    return """
      mutation{
          createUser(
            data: {
              name: "$name", email: "$email", password: "$password"}
                    )
                    {
                      name
                      email
                      password
                    }
          }
    """;
  }

  String getUsers(){
    return """ 
      {
        users{
          id
          name
          email
        }
      }
    """;
  }

  String deleteUser(id){
    return """
      mutation{
        deleteUser( where: {id: "$id"}){
          id
        }
      } 
    """;
  }

  String updateUser(String id, String name, String email, String password){
    return """
      mutation{
          updateUser( where: {id: "$id"}
          data: {name: "$name", email: "$email", password: "$password"})
          {
            name
            email
            password
          }
      }    
     """;
  }
}