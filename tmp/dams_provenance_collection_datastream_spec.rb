# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsProvenanceCollectionDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsProvenanceCollectionDatastream.new(stub('inner object', :pid=>'bb24242424', :new? => true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb24242424"
      end
    end

    describe "an instance with content" do
      subject do
        subject = DamsProvenanceCollectionDatastream.new(stub('inner object', :pid=>'bb24242424', :new? => true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsProvenanceCollection.rdf.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb24242424"
      end
      it "should have a title" do
        subject.titleValue.should == "Historical Dissertations"
      end
      it "should have a date" do
        subject.beginDate.should == ["2009-05-03"]
        subject.endDate.should == ["2010-06-30"]
      end
      it "should have a language" do
        subject.language.first.to_s.should == "#{Rails.configuration.id_namespace}bd0410344f"
      end

      it "should have notes" do
        solr_doc = subject.to_solr
        solr_doc["note_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        solr_doc["note_tesim"].should include "#{Rails.configuration.id_namespace}bb80808080"
        solr_doc["note_tesim"].should include "Linked note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        solr_doc["note_tesim"].should include "Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        solr_doc["note_tesim"].should include "Linked scope content note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end

      it "should index notes" do
        solr_doc = subject.to_solr
      end
      it "should have scopeContentNote" do
        testIndexNoteFields solr_doc,"scopeContentNote","Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end
      it "should have preferredCitationNote" do
        testIndexNoteFields solr_doc,"preferredCitationNote","Linked preferred citation note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end
      it "should have CustodialResponsibilityNote" do
        testIndexNoteFields solr_doc,"custodialResponsibilityNote","Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end  
      it "should have relationship" do
        subject.relationship.first.name.first.pid.should == "bb08080808"
        subject.relationship.first.role.first.pid.should == "bd55639754"
        solr_doc = subject.to_solr
        solr_doc["name_tesim"].should include "Artist, Alice, 1966-"
      end 

      it "should have event" do
        solr_doc = subject.to_solr
        solr_doc["event_1_type_tesim"].should == ["collection creation"]
        solr_doc["event_1_eventDate_tesim"].should == ["2012-11-06T09:26:34-0500"]
        solr_doc["event_1_outcome_tesim"].should == ["success"]
        solr_doc["event_1_name_tesim"].should == ["Administrator, Bob, 1977-"]
        solr_doc["event_1_role_tesim"].should == ["Initiator"]
      end              
      def testIndexNoteFields (solr_doc,fieldName,value)
        solr_doc["#{fieldName}_tesim"].should include value
      end    
    end

    describe "an instance with content" do
      subject do
        subject = DamsProvenanceCollectionDatastream.new(stub('inner object', :pid=>'bb24242424', :new? => true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/dissertation.rdf.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}xx1111111x"
      end

      it "should have fields" do
        subject.typeOfResource.should == ["text"]
        subject.titleValue.should == "Chicano and black radical activism of the 1960s"
      end

      it "should have collection" do
        #subject.collection.first.scopeContentNote.first.displayLabel == ["Scope and contents"]
        subject.collection.first.to_s.should ==  "#{Rails.configuration.id_namespace}bbXXXXXXX3"
      end

      it "should have inline subjects" do
        subject.subject[0].name.should == ["Black Panther Party--History"]
        subject.subject[1].name.should == ["African Americans--Relations with Mexican Americans--History--20th Century"]
      end
      it "should have external subjects" do
        subject.subject[0].should_not be_external
        subject.subject[1].should_not be_external
        subject.subject[2].should be_external
      end

      it "should have relationship" do
        subject.relationship[0].name.first.pid.should == "bbXXXXXXX1"
        subject.relationship[0].role.first.pid.should == "bd55639754"        
      end

      it "should have date" do
        subject.dateValue.should == ["2010"]
      end

      it "should create a solr document" do
        MadsComplexSubject.should_receive(:find).with('bbXXXXXXX5').and_return(stub(:name =>'stubbed'))
        #stub_person = stub(:name => "Maria")
        #DamsPerson.should_receive(:find).with("bbXXXXXXX1").and_return(stub_person)
        solr_doc = subject.to_solr
        solr_doc["subject_tesim"].should == ["Black Panther Party--History","African Americans--Relations with Mexican Americans--History--20th Century","stubbed"]
        solr_doc["title_tesim"].should include "Chicano and black radical activism of the 1960s: a comparison between the Brown Berets and the Black Panther Party in California"
        solr_doc["date_tesim"].should include "2010"
        solr_doc["name_tesim"].should include "Yañez, Angélica María"
      end
    end
  end 
end
