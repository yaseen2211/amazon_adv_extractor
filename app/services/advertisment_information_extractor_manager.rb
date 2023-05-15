class AdvertismentInformationExtractorManager
  attr_reader :worksheets, :spcs, :export_file, :results

  def initialize(export_file)
    @export_file         = export_file
    worksheets           = open_excel_file
    @spcs                = worksheets.select { |a| a.name == 'Sponsored Products Campaigns' }.first
    @results             = []
  end

  def extract_filtered_results
    return [] if spcs.blank? && spcs.rows.blank? #To check if specific sheet is available

    spcs.rows.each(headers: true).each do |row|
      is_not_relevant_record = (row["Entity"] != "Keyword" || (!row["Ad Group Name (Informational only)"]&.include?("NB")))
      next if is_not_relevant_record
      
      is_conditions_matched = match_filter_conditions?(row)
      results << required_for_print(row) if is_conditions_matched
    end
    results
  end



  private 

  def open_excel_file
    SimpleXlsxReader.open(@export_file).sheets
  end

  def match_filter_conditions?(row)
    is_sales_zero                          = row["Sales"].to_f == 0.0
    is_spended_equal_or_greater_to_dollar  = row["Spend"].to_f >= 1.0
    is_sales_zero and is_spended_equal_or_greater_to_dollar
  end

  def required_for_print(row)
    {
      group_name: row["Ad Group Name (Informational only)"],
      campaign_name: row["Campaign Name (Informational only)"],
      keyword_text: row["Keyword Text"],
      match_type: row["Match Type"],
      impressions: row["Impressions"],
      clicks: row["Clicks"],
      click_through: row["Click-through Rate"],
      spend: row["Spend"],
      sales: row["Sales"],
      orders: row["Orders"],
      units: row["Units"],
      conversion: row["Conversion Rate"],
      rate: row["ACOS"],
      cpc: row["CPC"],
      roas: row["ROAS"]
    } 
  end
end