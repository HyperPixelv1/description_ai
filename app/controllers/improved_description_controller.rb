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
      response = RestClient.post("http://example.com", {
        subject: subject,
        description: description,
      }.to_json, { content_type: :json, accept: :json })

      # Yanıtı parse et
      result = JSON.parse(response.body)

      # Orijinal verileri al
      original_subject = result.dig("original", "subject") || subject
      original_description = result.dig("original", "description") || description
      original_tags = result.dig("original", "tags") || []

      # Alternatifleri al
      alternatives = result["alternatives"] || []

      improved_descriptions = alternatives.map { |alt| alt["description"] }
      improved_tags = alternatives.flat_map { |alt| alt["tags"] }.uniq

      render json: {
        success: true,
        original: {
          subject: original_subject,
          description: original_description,
          tags: original_tags
        },
        alternatives: {
          descriptions: improved_descriptions,
          tags: improved_tags
        }
      }
      # Rails.logger.info "React API Response: #{response.body}"
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error "RestClient Error: #{e.response}"
      render json: { success: false, message: "API call failed: #{e.response}" }, status: :unprocessable_entity
    rescue => e
      Rails.logger.error "General Error: #{e.message}"
      render json: { success: false, message: "An unexpected error occurred: #{e.message}" }, status: :unprocessable_entity
    end
  end
end
