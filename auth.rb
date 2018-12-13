module Auth
  def self.login(session, user)
    session[:user_id] = user.id
    return session
  end

  def self.logout(session)
    return session.clear
  end

  def self.test
    p "This is a test"
  end

  def self.current_user
    User.find(session['user_id'])
  end
end
