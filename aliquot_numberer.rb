# NAME:	FreezerPro_aliquote.rb
# AUTHOR: Henrik Vestin Uppsala Biobank
# DATE: 2026 06 24
# HISTORY: 1.02
#		   
#		   
# COMMENT: Utgå från FreezerPro rapport för att skapa alikvotnumrering.
#
#==================================================================


require 'csv'

input_file = './csv/UBB-xx.csv'
output_file = './csv/UBB-yy.csv'
#Same filename should be safe to use, but be careful

aliquot = 0 #this will increment before first assignment
previous_key = nil
rows = []
headers = nil

CSV.foreach(input_file, col_sep: ';', headers: true) do |row|
  headers ||= row.headers + (row.headers.include?('ALIQUOT') ? [] : ['ALIQUOT'])

  current_key = row['name'] #Column containing key value, e.g. (NOPHO] Provnummer

  if current_key == previous_key
    #Same key: keep current aliquot value
  else
    #New key: increment aliquot value and reassign prevous_key
    aliquot += 1
    previous_key = current_key
  end

  
  row['ALIQUOT'] = aliquot # Assign aliquot to index 2 i.e column 3
  rows << row.fields

  CSV.open(output_file, col_sep: ';', 'w') do |csv|
    csv << headers
    rows.each { |row| csv << row }
  end

  puts "Done! ALIQUOT nr written to #{output_file}"
