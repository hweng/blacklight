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
        subject.content = File.new('/Users/yoonsukchang/damspas/spec/fixtures/damsProvenanceCollection.rdf.xml').read
        subject
      end
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bb24242424"
      end
      it "should have a title" do
        subject.titleValue.should == "Historical Dissertations"
      end
      it "should have a date_tesim and exact date" do
        subject.beginDate.should == ["2009-05-03"]
        subject.endDate.should == ["2010-06-30"]
      end
      it "should have language" do
        subject.language.first.pid.should == "bd0410344f"
      end
      it "should have scopeContentNote" do
        subject.scopeContentNote.first.pid.should == "bd1366006j"
      end
      it "should have note" do
        subject.note.first.pid.should == "bd52568274"
      end
      it "should have repeated fields for Note" do
        solr_doc = subject.to_solr
        solr_doc["note_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
        solr_doc["note_tesim"].should include "http://library.ucsd.edu/ark:/20775/bb80808080"
      end
      it "should have custodialResponsibilityNote" do
        subject.custodialResponsibilityNote.first.pid.should == "bd9113515d"
      end
      it "should have preferredCitationNote" do
        subject.preferredCitationNote.first.pid.should == "bd3959888k"
      end
      it "should have relationship" do
        subject.relationship.first.role.first.pid.should == "bd55639754"
        subject.relationship.first.name.first.pid.should == "bb08080808"
      end
      it "should have hasPart" do
        subject.hasPart.first.pid.should == "bb25252525"
      end
      it "should have event" do
        subject.event.first.pid.should == "bb29292929"
      end
    end
  end 
end
