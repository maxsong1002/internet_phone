class CallsController < ApplicationController
    skip_before_filter  :verify_authenticity_token

    def new
        # Find these values at twilio.com/user/account
        account_sid = ENV['ACCOUNT_SID']
        auth_token = ENV['AUTH_TOKEN']
        capability = Twilio::Util::Capability.new account_sid, auth_token
        capability.allow_client_outgoing "AP4f310830a7a8eb025f0519bd997663c7"
        capability.allow_client_incoming "internet_phone"
        @token = capability.generate
    end

    def voice
        number = params[:PhoneNumber]
        caller_id = "+14702354516"
        response = Twilio::TwiML::Response.new do |r| # response to Twilio server's request
            r.Dial :callerId => caller_id do |d|
                if /^[\d\+\-\(\) ]+$/.match(number) # if a valid number is given
                    d.Number(CGI::escapeHTML number) # call the number
                else
                    d.Client 'internet_phone' # call the internet phone
                end
            end
        end
        render :text => response.text #return TwiML xml to send to Twilio server.
    end
end