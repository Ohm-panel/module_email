### Ohm E-mail module <http://joelcogen.com/projects/ohm/> ###
#
# Users controller
#
# Copyright (C) 2010 Joel Cogen <http://joelcogen.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this module. If not, see <http://www.gnu.org/licenses/>.
#
# This program incorporates work covered by the following copyright and
# permission notice:
#
#   Copyright (C) 2009-2010 UMONS <http://www.umons.ac.be>
#   All rights reserved.
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are met:
#
#   - Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#   - Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#   - Neither the name of UMONS nor the names of its contributors may be used
#     to endorse or promote products derived from this software without specific
#     prior written permission.
#
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
#   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
#   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#   POSSIBILITY OF SUCH DAMAGE.

class ServiceEmailUsersController < ServiceEmailController
  before_filter :authenticate_email_user

  def controller_name
    "e-mail"
  end

  # GET /service_email_users/1
  # GET /service_email_users/1.xml
  def show
    if params[:user_id]
      @service_email_user = ServiceEmailUser.find(:first, :conditions => { :user_id => params[:user_id] })
    elsif params[:id]
      @service_email_user = ServiceEmailUser.find(params[:id])
    end
  end

  # GET /service_email_users/new
  # GET /service_email_users/new.xml
  def new
    @service_email_user = ServiceEmailUser.new(:user_id => params[:user_id])
    @user = User.find(params[:user_id])
  end

  # GET /service_email_users/1/edit
  def edit
    @service_email_user = ServiceEmailUser.find(params[:id])
  end

  # POST /service_email_users
  # POST /service_email_users.xml
  def create
    @service_email_user = ServiceEmailUser.new(params[:service_email_user])

    if @service_email_user.save
      flash[:notice] = 'E-mail service successfully added.'
      redirect_to @service_email_user.user
    else
      render :action => "new"
    end
  end

  # PUT /service_email_users/1
  # PUT /service_email_users/1.xml
  def update
    @service_email_user = ServiceEmailUser.find(params[:id])

   if @service_email_user.update_attributes(params[:service_email_user])
      flash[:notice] = 'ServiceEmailUser was successfully updated.'
      redirect_to @service_email_user.user
    else
      render :action => "edit"
    end
  end
end

