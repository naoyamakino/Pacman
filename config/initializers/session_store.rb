# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pacman_session',
  :secret      => '3de4e11ef557b96b4202359823a8b197d548450596b6887b6a2bee7a01adc41c3a4aa05e13aa55f1a03945147f6c0806541d78b4922f7065a34dab999ecea06a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
