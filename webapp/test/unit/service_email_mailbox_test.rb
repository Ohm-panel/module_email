### Ohm E-mail module <http://joelcogen.com/projects/ohm/> ###
#
# Mailbox test
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

require 'test_helper'

class ServiceEmailMailboxTest < ActiveSupport::TestCase
  test "valid fixtures" do
    assert service_email_mailboxes(:local).valid?, "fixtures: local is invalid"
    assert service_email_mailboxes(:alias).valid?, "fixtures: alias is invalid"
  end

  test "invalid without address, domain or password" do
    mbox = ServiceEmailMailbox.new
    mbox.save
    assert mbox.errors.invalid?(:address), "Blank address accepted"
    assert mbox.errors.invalid?(:domain_id), "Blank domain accepted"
    assert mbox.errors.invalid?(:password), "Blank password accepted"
  end

  test "password change" do
    mbox = service_email_mailboxes(:local)
    mbox.password = "new password"
    mbox.password_confirmation = mbox.password
    assert mbox.valid?, "Good new password rejected"

    mbox.password_confirmation = "something else"
    mbox.save
    assert mbox.errors.invalid?(:password_confirmation), "Incorrect password confirmation accepted"
  end

  test "address format" do
    mbox = service_email_mailboxes(:local)
    mbox.address = "valid.email_address-ok"
    assert mbox.valid?, "Good address rejected"

    mbox.address = "invalid@address"
    mbox.save
    assert mbox.errors.invalid?(:address), "Bad address accepted"

    mbox.address = "invalid address"
    mbox.save
    assert mbox.errors.invalid?(:address), "Bad address accepted"

    mbox.address = "invalid+address"
    mbox.save
    assert mbox.errors.invalid?(:address), "Bad address accepted"
  end

  test "address unique for domain" do
    mbox = ServiceEmailMailbox.new(:address   => service_email_mailboxes(:local).address,
                                   :domain_id => service_email_mailboxes(:local).domain_id,
                                   :password  => "some password")
    mbox.save
    assert mbox.errors.invalid?(:address), "Duplicate address accepted"

    mbox.domain_id = 2
    assert mbox.valid?, "Duplicate address on different domain rejected"
  end
end

