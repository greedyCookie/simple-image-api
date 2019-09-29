object false
node(:access_token) { @access_token.token }

node(:user) { partial("api/v1/users/user", object: @user) }
