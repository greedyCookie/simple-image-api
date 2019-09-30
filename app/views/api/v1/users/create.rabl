object @user => false
node(:access_token) { @access_token.token }

extends "api/v1/users/user", object: @user
