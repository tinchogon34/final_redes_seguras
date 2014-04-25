require 'digest/sha2'

class SessionsController < ApplicationController
  # Vista de login de usuario GET /sessions/new
  def new
    session[:coord_1_value] = session[:coord_2_value] = session[:step1_user] = nil
  end

  # Vista donde se ingresan las coordenadas GET /sessions/coords
  def coords
    if flash[:one_time_coords].nil? or session[:step1_user].nil? # Volver al principio si el login no ha sido exitoso, o si se ha apretado f5 en la misma pagina
      flash[:alert] = "Error en las coordenadas"
      return redirect_to users_sign_in_path 
    end

    user = User.find(session[:step1_user])

    
    # Buscar 2 coordenadas diferentes al azar y guardar tanto su indice (E5) como su valor (78) por ej.
    @coord_1_text = CoordCard.rand_coord

    begin
      @coord_2_text = CoordCard.rand_coord
    end while @coord_1_text == @coord_2_text

    session[:coord_1_value] = user.coord_card.coord_card_items.where(coord: @coord_1_text).first.value
    session[:coord_2_value] = user.coord_card.coord_card_items.where(coord: @coord_2_text).first.value
  end

  # POST donde pega el primer formulario de login POST /sessions/login_step_1
  def login_step_1
    user = User.where("username = :username_email OR email = :username_email",username_email: params[:user][:username_email]).first

    if user and user.valid_password? params[:user][:password]
      flash[:one_time_coords] = true # Variable que dura 1 sola sesion para prevenir el refresco de coordenadas en la pagina /coords
      session[:step1_user] = user.id # Indica un login exitoso y al mismo tiempo guarda el usuario para poder traer los valores de las coordenadas aleatorias
      user.update_attributes last_login_at: Time.now # Setea la hora de login para poder chequear luego que el horario no tenga mas de 1 minuto de diferencia
      flash[:notice] = "Por favor ingrese las coordenadas solicitadas (Tiempo maximo 1 minuto)"
      return redirect_to users_sign_in_step_2_path 
    end
    
    flash[:alert] = "Error en los datos"
    return redirect_to users_sign_in_path    
  end

  def login_step_2    
    user = User.find(session[:step1_user])

    if Time.now > (user.last_login_at + 1.minute)
      flash[:alert] = "La solicitud ha expirado"
      return redirect_to users_sign_in_path  
    end
    
    if session[:coord_1_value] == (Digest::SHA2.new << (params[:user][:coord_1_value] + user.encrypted_password)).to_s and (Digest::SHA2.new << (params[:user][:coord_2_value] + user.encrypted_password)).to_s
      session[:current_user_id],session[:step1_user] = session[:step1_user], nil
      session[:coord_1_value] = session[:coord_2_value] = nil
      flash[:notice] = "Logeado con exito"
      return redirect_to root_url      
    end
    
    user.update_attributes(last_login_at: nil)
    flash[:alert] = "Error en las coordenadas"
    return redirect_to users_sign_in_path
  end

  def destroy
    session.clear
    flash[:notice] = "Deslogeado con exito"
    return redirect_to users_sign_in_path
  end
end
