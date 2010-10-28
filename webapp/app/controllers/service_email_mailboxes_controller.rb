### Ohm E-mail module <http://joelcogen.com/projects/ohm/> ###
#
# Mailboxes controller
#
# Copyright (C) 2010 Joel Cogen <http://joelcogen.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
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

class ServiceEmailMailboxesController < ServiceEmailController
  before_filter :authenticate_email_user

  def controller_name
    "e-mail"
  end

  # GET /service_email_mailboxes
  # GET /service_email_mailboxes.xml
  def index
    @mailboxes = ServiceEmailMailbox.all
  end

  # GET /service_email_mailboxes/new
  # GET /service_email_mailboxes/new.xml
  def new
    @mailbox = ServiceEmailMailbox.new
  end

  # GET /service_email_mailboxes/1/edit
  def edit
    @mailbox = ServiceEmailMailbox.find(params[:id])

    unless @logged_user.domains.include? @mailbox.domain
      flash[:error] = 'Invalid mailbox'
      redirect_to :action => 'index'
    end
  end

  # POST /service_email_mailboxes
  # POST /service_email_mailboxes.xml
  def create
    @mailbox = ServiceEmailMailbox.new(params[:service_email_mailbox])
    legal_domain = @logged_user.domains.include? @mailbox.domain

    if legal_domain and @mailbox.save
      flash[:notice] = "Mailbox successfully created.#{@@changes}"
      redirect_to :action => 'index'
    else
      @mailbox.errors.add(:domain_id, 'is not managed by you') unless legal_domain
      render :action => 'new'
    end

  end

  # PUT /service_email_mailboxes/1
  # PUT /service_email_mailboxes/1.xml
  def update
    @mailbox = ServiceEmailMailbox.find(params[:id])
    @newatts = params[:service_email_mailbox]
    if @newatts[:password] == ''
      @newatts[:password_confirmation] = nil
      @newatts[:password] = @mailbox.password
    end

    if not @logged_user.domains.include? @mailbox.domain
      flash[:error] = 'Invalid mailbox'
      redirect_to :action => 'index'
    elsif @mailbox.update_attributes(params[:service_email_mailbox])
      flash[:notice] = @mailbox.full_address + " was successfully updated.#{@@changes}"
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  # DELETE /service_email_mailboxes/1
  # DELETE /service_email_mailboxes/1.xml
  def destroy
    @mailbox = ServiceEmailMailbox.find(params[:id])

    if @logged_user.domains.include? @mailbox.domain
      @mailbox.destroy

      flash[:notice] = @mailbox.full_address + " was successfully deleted.#{@@changes}"
      redirect_to :action => 'index'
    else
      flash[:error] = 'Invalid mailbox'
      redirect_to :action => 'index'
    end
  end
end

