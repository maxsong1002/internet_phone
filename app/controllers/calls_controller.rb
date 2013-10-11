class CallsController < ApplicationController
    def new
        # Find these values at twilio.com/user/account
        account_sid = 'AC836fb64c292cc774507c412443b7adb1'
        auth_token = '9085867319e82a04eb3a5c68ad7ce310'
        # This application sid will play a Welcome Message.
        demo_app_sid = 'APabe7650f654fc34655fc81ae71caa3ff'
        capability = Twilio::Util::Capability.new account_sid, auth_token
        capability.allow_client_outgoing "AP4f310830a7a8eb025f0519bd997663c7"
        capability.allow_client_incoming "internet_phone"
        capability.allow_client_outgoing demo_app_sid #making a call to the demo_app
        @token = capability.generate
    end

    def incoming_call
        number = params[:PhoneNumber]
        response = Twilio::TwiML::Response.new do |r|
            # Should be your Twilio Number or a verified Caller ID
            r.Dial :callerId => caller_id do |d|
                if /^[\d\+\-\(\) ]+$/.match(number)
                    d.Number(CGI::escapeHTML number)
                else
                    d.Client 'internet_phone'
                end
            end
        end
        response.text
    end
end