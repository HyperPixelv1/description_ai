class ImprovedDescriptionController < ApplicationController
  # React programına subject ve description gönderir
  def improve_description
    subject = params[:subject].to_s
    description = params[:description].to_s

    if subject.blank? || description.blank?
      render json: { success: false, message: "Subject and description cannot be blank." }, status: :unprocessable_entity
      return
    end

    begin
      # React programına HTTP isteği yapın
      response = RestClient.post("http://example", {
        subject: subject,
        description: description,
      }.to_json, { content_type: :json, accept: :json })

      # Yanıtı parse et
      result = JSON.parse(response.body)

      render json: result.merge(success: true)
      
    Rails.logger.info "React API Response: #{response.body}"
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error "RestClient Error: #{e.response}"
      render json: { success: false, message: "API call failed: #{e.response}" }, status: :unprocessable_entity
    rescue => e
      Rails.logger.error "General Error: #{e.message}"
      render json: { success: false, message: "An unexpected error occurred: #{e.message}" }, status: :unprocessable_entity
    end
  end
end
