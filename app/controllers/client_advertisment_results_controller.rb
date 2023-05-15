class ClientAdvertismentResultsController < ApplicationController

  def adv_file_uploader ; end
  
  def process_results
    advertisment_export_file  = client_advertisment_upload_params[:export_file]
    ace_obj                   = AdvertismentInformationExtractorManager.new(advertisment_export_file)
    @filtered_results         = ace_obj.extract_filtered_results

    respond_to do |format|
      if @filtered_results.present?
        format.html { redirect_to extract_adv_results_path, notice: "Results have benn generated successfully." }
        format.turbo_stream { render_turbo_stream(@filtered_results) }
      else
        format.html { render :root_path, status: :unprocessable_entity }
        format.turbo_stream { render_turbo_stream([]) }
      end
    end
  end

  private 

  def client_advertisment_upload_params
    params.require(:client_advertisments).permit(:export_file)
  end

  def render_turbo_stream(filtered_results)
    render turbo_stream: [
      turbo_stream.replace(:adv_extracted_results, partial: "client_advertisment_results/tabular_results", locals: { results: filtered_results })
    ]
  end
end
