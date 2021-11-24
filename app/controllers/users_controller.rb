class UsersController < ApplicationController
  

  def index
    add_breadcrumb 'Usuarios'
    @headers = current_cadmin_user.superadmin? ? ['NOMBRE', 'APELLIDO','TELEFONO','EMAIL', 'REGISTRO','ROL'] : ['NOMBRE', 'APELLIDO','TELEFONO','EMAIL']
    @attrs = current_cadmin_user.admin? ? [:name,:last_name, :phone, :email, :created_at, :role] : [:name,:last_name,:phone,:email]
    
    result = User.order(params[:sort])
    @pagy, @users = pagy(User.all, items: 10)

  end
end
