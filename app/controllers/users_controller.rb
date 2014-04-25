require 'digest/sha2'

class UsersController < ApplicationController
  before_action :user_params, only: [:create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.update_attributes(confirm_token: (Digest::SHA2.new << (@user.email + Time.now.to_s)).to_s)
      UserMailer.confirmation_email(@user).deliver
      flash[:notice] = "Registrado con exito, por favor confirme su registro dentro de los 30 minutos"
      return redirect_to users_sign_in_path
    else
      render action: 'new'
    end
  end

  def confirm
    user = User.find_by(email: params[:email]) if params[:email]
    return redirect_to users_sign_in_path if user.nil? or params[:token].nil? or user.confirmed?

    if Time.now > (user.created_at + 30.minutes)
      flash[:alert] = "El token ha expirado"
      return redirect_to users_sign_in_path
    end

    if user.confirm_token == params[:token]
      user.update_attributes(confirm_token: nil)
      coord_card = CoordCard.generate!(user)
      csv = coord_card.to_csv(col_sep: "\t", force_quotes: true)
      coord_card.encrypt!
      send_data csv, filename: "coordenadas.xls", type: :xls      
    end
  end

  private

  def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end  
end