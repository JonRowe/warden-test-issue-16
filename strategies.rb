Warden::Strategies.add(:basic) do

  def auth
    @auth ||= Rack::Auth::Basic::Request.new(env)
  end

  def valid?
    auth.provided? && auth.basic? && auth.credentials
  end

  def authenticate!;  true; end
  def store?;        false; end

  def unauthorized
    [ 401, { 'Content-Type' => 'text/plain', 'Content-Length' => '0', 'WWW-Authenticate' => %(Basic realm="realm") }, [] ]
  end

end

Warden::Strategies.add(:password) do
  def valid?;        false; end
  def authenticate!; false; end
  def store?;        false; end

  def unauthorized
    [ 401, {}, [] ]
  end
end
