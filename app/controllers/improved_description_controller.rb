class ImprovedDescriptionController < ApplicationController
  # React programına subject ve description gönderir
  def improve_description
    issue = Issue.find(params[:issue_id])
    subject = issue.subject
    description = issue.description

    # React programına HTTP isteği yapın
    response = RestClient.post("http://example", {
      subject: subject,
      description: description,
    }.to_json, { content_type: :json, accept: :json })

    # React programından gelen description'ları ve etiketleri alır
    result = JSON.parse(response.body)
    improved_descriptions = result["descriptions"] # Birden fazla description dönmesi bekleniyor
    tags = result["tags"]

    # Kullanıcının kendi description'unu ve gelen description'ları listeye ekle
    descriptions_list = [description] + improved_descriptions

    # Etiketleri kaydet
    issue.tag_list.add(tags)
    issue.save

    render json: { success: true, descriptions: descriptions_list }
  rescue => e
    render json: { success: false, message: e.message }, status: :unprocessable_entity
  end
end
