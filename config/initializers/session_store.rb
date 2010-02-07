# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tavio_session',
  :secret      => 'b1295cf9e2e8e278357808ce198b7c44be6c58444fa3e473f4755ebce1b820db50450c7ca325467ac38df91aaae0dbf06f22d6f6dd96bc3f78da7d10f16cad72'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
