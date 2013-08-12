# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsProvenanceCollectionDatastream do

  describe "a provenance collection model" do

    describe "instance populated in-memory" do
      subject { DamsProvenanceCollectionDatastream.new(stub('inner object', :pid=>'bb24242424', :new? => true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb24242424"
      end
    end

    describe "an instance loaded from fixture xml" do
      subject do
        subject = DamsProvenanceCollectionDatastream.new(stub('inner object', :pid=>'bb24242424', :new? =>true), 'damsMetadata')
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
        subject.language.first.pid.should == "bd0410344f"
      end
      it "should have notes" do
        subject.note.first.pid.should == "bd52568274"
        solr_doc = subject.to_solr
        solr_doc["note_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        solr_doc["note_tesim"].should include "#{Rails.configuration.id_namespace}bb80808080"
        solr_doc["note_tesim"].should include "Linked note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        solr_doc["note_tesim"].should include "Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        solr_doc["note_tesim"].should include "Linked scope content note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end

      it "should have scopeContentNote" do
        subject.scopeContentNote.first.pid.should == "bd1366006j"
        solr_doc = subject.to_solr
        testIndexNoteFields solr_doc,"scopeContentNote","Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end
      it "should have preferredCitationNote" do
        subject.preferredCitationNote.first.pid.should == "bd3959888k"
        solr_doc = subject.to_solr 
        testIndexNoteFields solr_doc,"preferredCitationNote","Linked preferred citation note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end
      it "should have CustodialResponsibilityNote" do
        subject.custodialResponsibilityNote.first.pid.should == "bd9113515d"
        solr_doc = subject.to_solr
        testIndexNoteFields solr_doc,"custodialResponsibilityNote","Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
      end  
      it "should have relationship" do
        subject.relationship.first.name.first.pid.should == "bb08080808"
        subject.relationship.first.role.first.pid.should == "bd55639754"
        solr_doc = subject.to_solr
        solr_doc["name_tesim"].should include "Artist, Alice, 1966-"
      end 
      it "should have event" do
        subject.event.first.pid.should == "bb29292929"
      end              
      def testIndexNoteFields (solr_doc,fieldName,value)
        solr_doc["#{fieldName}_tesim"].should include value
      end    
      it "should index parts" do
        solr_doc = subject.to_solr
        solr_doc["part_name_tesim"].should == ["May 2009"]
        solr_doc["part_id_tesim"].should == ["bb25252525"]
        solr_doc["part_json_tesim"].should == ['{"id":"bb25252525","name":"May 2009"}']
      end
    end

    describe "an instance loaded from an xml file" do
      subject do
        subject = DamsProvenanceCollectionDatastream.new(stub('inner object', :pid=>'bd48133407', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsProvenanceCollection.xml').read
        subject
      end

      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bd48133407"
      end
      it "should have a personal name" do
        solr_doc = subject.to_solr
        solr_doc["personalName_tesim"].should == ["Smith, John, Dr., 1965-"]
      end
      it "should have a geographic value" do
        solr_doc = subject.to_solr
        solr_doc["geographic_tesim"].should == ["mads:Geographic value"]
      end   
      it "should have a iconography value" do
        solr_doc = subject.to_solr
        solr_doc["iconography_tesim"].should == ["dams:Iconography value"]
      end   
      it "should have a occupation value" do
        solr_doc = subject.to_solr
        solr_doc["occupation_tesim"].should == ["mads:Occupation value"]
      end      
      it "should have a conference value" do
        solr_doc = subject.to_solr
        solr_doc["conferenceName_tesim"].should == ["mads:ConferenceName value"]
      end      
      it "should have a genreForm value" do
        solr_doc = subject.to_solr
        solr_doc["genreForm_tesim"].should == ["mads:GenreForm value"]
      end      
      it "should have a builtWorkPlace value" do
        solr_doc = subject.to_solr
        solr_doc["builtWorkPlace_tesim"].should == ["dams:BuiltWorkPlace value"]
      end      
      it "should have a event" do
        subject.event.first.pid.should == "bd9830448w"
      end      
      it "should have a corporateName value" do
        solr_doc = subject.to_solr
        solr_doc["corporateName_tesim"].should == ["mads:CorporateName value"]
      end      
      it "should have a function value" do
        solr_doc = subject.to_solr
        solr_doc["function_tesim"].should == ["dams:Function value"]
      end      
      it "should have a date" do
        solr_doc = subject.to_solr
        solr_doc["date_tesim"].should include "Easter 2012"
        solr_doc["date_tesim"].should include "2012-04-08"
        solr_doc["date_tesim"].should include "2012-04-08"
      end      
      it "should have a preferredCitationNote" do
        solr_doc = subject.to_solr
        solr_doc["preferredCitationNote_tesim"].should == ["PreferredCitationNote value"]
      end     
      it "should have a note" do
        solr_doc = subject.to_solr
        solr_doc["note_tesim"].should include "http://library.ucsd.edu/ark:/20775/bd48133407"
        solr_doc["note_tesim"].should include "1 digital object."
        solr_doc["note_tesim"].should include "CustodialResponsibilityNote value"
        solr_doc["note_tesim"].should include "PreferredCitationNote value"
        solr_doc["note_tesim"].should include "ScopeContentNote value"
      end     
      it "should have a event" do
        subject.event.first.pid.should == "bd9830448w"
      end  
      it "should have a language" do
        subject.language.first.pid.should == "bd0410344f"
      end 
      it "should have a temporal value" do
        solr_doc = subject.to_solr
        solr_doc["temporal_tesim"].should == ["mads:Temporal value"]
      end 
      it "should have relationship" do
        subject.relationship.first.role.first.pid.should == "bd0785823z"
        subject.relationship.first.personalName.first.pid.should == "bd6860945s"
      end 
      it "should have a culturalContext value" do
        solr_doc = subject.to_solr
        solr_doc["culturalContext_tesim"].should == ["dams:CulturalContext value"]
      end 
      it "should have a topic value" do
        solr_doc = subject.to_solr
        solr_doc["topic_tesim"].should == ["mads:Topic value"]
      end 
      it "should have a stylePeriod value" do
        solr_doc = subject.to_solr
        solr_doc["stylePeriod_tesim"].should == ["dams:StylePeriod value"]
      end 
      it "should have a complxSubject" do
        solr_doc = subject.to_solr
        solr_doc["complexSubject_tesim"].should == ["mads:Topic value--mads:Temporal value"]
      end
      it "should have a topic" do
        solr_doc = subject.to_solr
        solr_doc["topic_tesim"].should == ["mads:Topic value"]
      end
      it "should have a temporal" do
        solr_doc = subject.to_solr
        solr_doc["temporal_tesim"].should == ["mads:Temporal value"]
      end
      it "should have a technique" do
        solr_doc = subject.to_solr
        solr_doc["technique_tesim"].should == ["mads:Technique value"]
      end
      it "should have a title" do
        solr_doc = subject.to_solr
        solr_doc["title_tesim"].should == ["Sample Provenance Collection, The: Subtitle, Allegro, 1"]
      end       
      it "should have a scientificName value" do
        solr_doc = subject.to_solr
        solr_doc["scientificName_tesim"].should == ["dams:ScientificName value"]
      end 
      it "should have a familyName value" do
        solr_doc = subject.to_solr
        solr_doc["familyName_tesim"].should == ["mads:FamilyName value"]
      end      
      it "should have a name value" do
        solr_doc = subject.to_solr
        solr_doc["name_tesim"].should == ["Wagner, Rick, 1972-", "mads:Name value"]
      end
    end
  end
end
