require 'spec_helper'

# Class to store the path of the provenance collection
class Path
	class << self
		attr_accessor :path
	end
	@path = nil
end

# Variable to be used to store provenance collection path
# Used for editing provenance collection
feature 'Visitor wants to create/edit a provenance collection' do 
	scenario 'is on dams provenance collection page' do
		sign_in_developer
		# click create button
		visit "dams_provenance_collections/new"
		# Create new dams provenance collection
		fill_in "First Title", :with => "TestTitle"
		fill_in "First SubTitle", :with => "TestSubTitle"
		fill_in "First PartName", :with => "TestPartName"
		fill_in "First PartNumber", :with => "TestPartNumber"
		fill_in "First NonSort", :with => "TestNonSort"
		fill_in "Date", :with => "TestDate"
		fill_in "Begin Date", :with => "TestBeginDate"
		fill_in "End Date", :with => "TestEndDate"
		fill_in "Note", :with => "TestNote"
		fill_in "Note Type", :with => "TestNoteType"
		fill_in "Note Displaylabel", :with => "TestNoteDisplaylabel"
		fill_in "Scope Content Note", :with => "TestScopeContentNote"
		fill_in "Scope Content Note Type", :with => "TestScopeContentNoteType"
		page.select('Test Simple Subject', match: :first) 
		fill_in "Simple Subject", :with => "TestSimpleSubject"
		page.select('Test Complex Subject', match: :first) 
		fill_in "Complex Subject", :with => "TestComplexSubject"
		fill_in "Related Resource Type", :with => "TestRelatedResourceType"
		fill_in "Related Resource URI", :with => "TestRelatedResourceURI"
		fill_in "Related Resource Description", :with => "TestRelatedResourceDescription"
		page.select('Test Language', match: :first) 
		page.select('Test dams object', match: :first) 
		page.select('Test Provenance Collection Part', match: :first) 
		click_on "Save"

		# Save path of provenance collection and expect results
		Path.path = current_path
		expect(Path.path).to eq(current_path)
		expect(page).to have_content ("TestTitle")
		expect(page).to have_content ("TestSubTitle")
		expect(page).to have_content ("TestPartName")
		expect(page).to have_content ("TestPartNumber")
		expect(page).to have_content ("TestNonSort")
		expect(page).to have_content ("TestDate")
		expect(page).to have_content ("TestBeginDate")
		expect(page).to have_content ("TestEndDate")
		expect(page).to have_content ("TestNote")
		expect(page).to have_content ("TestNoteType")
		expect(page).to have_content ("TestNoteDisplaylabel")
		expect(page).to have_content ("TestScopeContentNote")
		expect(page).to have_content ("TestScopeContentNoteType")
		expect(page).to have_content ("Test Simple Subject")
		expect(page).to have_content ("TestSimpleSubject")
		expect(page).to have_content ("Test Complex Subject")
		expect(page).to have_content ("TestComplexSubject")
		expect(page).to have_content ("TestRelatedResourceType")
		expect(page).to have_content ("TestRelatedResourceURI")
		expect(page).to have_content ("TestRelatedResourceDescription")
		expect(page).to have_content ("Test Language")
		expect(page).to have_content ("Test dams object")
		expect(page).to have_content ("Test Provenance Collection Part")

		# Edit provenance collection
		expect(page).to have_selector('a', :text => "Edit")
		expect(page).to have_selector('a', :text => "View All")
		click_on "Edit"
		fill_in "First Title", :with => "EditTestTitle"
		fill_in "First SubTitle", :with => "EditTestSubTitle"
		fill_in "First PartName", :with => "EditTestPartName"
		fill_in "First PartNumber", :with => "EditTestPartNumber"
		fill_in "First NonSort", :with => "EditTestNonSort"
		fill_in "Date", :with => "EditTestDate"
		fill_in "Begin Date", :with => "EditTestBeginDate"
		fill_in "End Date", :with => "EditTestEndDate"
		fill_in "Note", :with => "EditTestNote"
		fill_in "Note Type", :with => "EditTestNoteType"
		fill_in "Note Displaylabel", :with => "EditTestNoteDisplaylabel"
		fill_in "Scope Content Note", :with => "EditTestScopeContentNote"
		fill_in "Scope Content Note Type", :with => "EditTestScopeContentNoteType"
		page.select('Edit Test Simple Subject', match: :first) 
		fill_in "Simple Subject", :with => "EditTestSimpleSubject"
		page.select('Edit Test Complex Subject', match: :first) 
		fill_in "Complex Subject", :with => "EditTestComplexSubject"
		fill_in "Related Resource Type", :with => "EditTestRelatedResourceType"
		fill_in "Related Resource URI", :with => "EditTestRelatedResourceURI"
		fill_in "Related Resource Description", :with => "EditTestRelatedResourceDescription"
		page.select('Edit Test Language', match: :first) 
		page.select('Edit Test dams object', match: :first) 
		page.select('Edit Test Provenance Collection Part', match: :first) 
		click_on "Save"

		# Check that changes are saved
		expect(page).to have_content ("EditTestTitle")
		expect(page).to have_content ("EditTestSubTitle")
		expect(page).to have_content ("EditTestPartName")
		expect(page).to have_content ("EditTestPartNumber")
		expect(page).to have_content ("EditTestNonSort")
		expect(page).to have_content ("EditTestDate")
		expect(page).to have_content ("EditTestBeginDate")
		expect(page).to have_content ("EditTestEndDate")
		expect(page).to have_content ("EditTestNote")
		expect(page).to have_content ("EditTestNoteType")
		expect(page).to have_content ("EditTestNoteDisplaylabel")
		expect(page).to have_content ("EditTestScopeContentNote")
		expect(page).to have_content ("EditTestScopeContentNoteType")
		expect(page).to have_content ("Edit Test Simple Subject")
		expect(page).to have_content ("EditTestSimpleSubject")
		expect(page).to have_content ("Edit Test Complex Subject")
		expect(page).to have_content ("EditTestComplexSubject")
		expect(page).to have_content ("EditTestRelatedResourceType")
		expect(page).to have_content ("EditTestRelatedResourceURI")
		expect(page).to have_content ("EditTestRelatedResourceDescription")
		expect(page).to have_content ("Edit Test Language")
		expect(page).to have_content ("Edit Test dams object")
		expect(page).to have_content ("Edit Test Provenance Collection Part")
	end
end

feature 'Visitor wants to cancel unsaved edits' do
	scenario 'is on Edit Provenance Collection page' do
		sign_in_developer
		visit Path.path
		expect(page).to have_selector('a', :text => "Edit")
		click_on "Edit"
		fill_in "First Title", :with => "CancelTestTitle"
		fill_in "First SubTitle", :with => "CancelTestSubTitle"
		fill_in "First PartName", :with => "CancelTestPartName"
		fill_in "First PartNumber", :with => "CancelTestPartNumber"
		fill_in "First NonSort", :with => "CancelTestNonSort"
		fill_in "Date", :with => "CancelTestDate"
		fill_in "Begin Date", :with => "CancelTestBeginDate"
		fill_in "End Date", :with => "CancelTestEndDate"
		fill_in "Note", :with => "CancelTestNote"
		fill_in "Note Type", :with => "CancelTestNoteType"
		fill_in "Note Displaylabel", :with => "CancelTestNoteDisplaylabel"
		fill_in "Scope Content Note", :with => "CancelTestScopeContentNote"
		fill_in "Scope Content Note Type", :with => "CancelTestScopeContentNoteType"
		page.select('Cancel Test Simple Subject', match: :first) 
		fill_in "Simple Subject", :with => "CancelTestSimpleSubject"
		page.select('Edit Test Complex Subject', match: :first) 
		fill_in "Complex Subject", :with => "CancelTestComplexSubject"
		fill_in "Related Resource Type", :with => "CancelTestRelatedResourceType"
		fill_in "Related Resource URI", :with => "CancelTestRelatedResourceURI"
		fill_in "Related Resource Description", :with => "CancelTestRelatedResourceDescription"
		page.select('Cancel Test Language', match: :first) 
		page.select('Cancel Test dams object', match: :first) 
		page.select('Cancel Test Provenance Collection Part', match: :first) 
		click_on "Cancel"
		expect(page).to_not have_content("Should not show")
	end
end

def sign_in_developer
	visit new_user_session_path
	fill_in "Name", :with => "name"
	fill_in "Email", :with => "email@email.com"
	click_on "Sign In"
end