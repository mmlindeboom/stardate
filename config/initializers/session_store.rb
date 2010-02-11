# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_stardate_session',
  :secret => '3afb7702aa8dcd4423b9245ad20379388d8e115b642762211c8e22ef7f6d77a857dc1e6b8820f324ab33d5b0d967a09451284f764c3e53f4cda65eaac5d1548b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
