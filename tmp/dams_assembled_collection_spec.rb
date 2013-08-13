require 'spec_helper'

describe DamsAssembledCollection do
  before  do
    @damsAssembledCollection = DamsObject.new(pid: 'bb03030303')
  end
  
  it "should create/update a title" do
    @damsAssembledCollection.title.build
    @damsAssembledCollection.titleValue = "UCSD Electronic Theses and Dissertations<"
    @damsAssembledCollection.titleValue.should == "UCSD Electronic Theses and Dissertations<"
  end

  it "should create/update a subject" do
    @damsAssembledCollection.topic.build
    @damsAssembledCollection.topic.first.name = "topic 1"
    @damsAssembledCollection.topic.first.name.should == ["topic 1"]
    @damsAssembledCollection.topic << MadsTopic.new( :name => "topic 2" )
    pending "should be able to access second and subsequent topics..."
    @damsAssembledCollection.topic[1].name.should == ["topic 2"]

    @damsAssembledCollection.topic.first.name = "topic 3"
    @damsAssembledCollection.topic.first.name.should == ["topic 3"]
    @damsAssembledCollection.topic.second.name = "topic 4"
    @damsAssembledCollection.topic.second.name.should == ["topic 4"]
  end

  describe "Store to a repository" do
    before do
      MadsPersonalName.create! pid: "zzXXXXXXX1", name: "Maria", externalAuthority: "someUrl"
    end
    after do
      #@damsObj.delete
    end
    it "should store/retrieve from a repository" do
      @damsAssembledCollection.damsMetadata.content = File.new('spec/fixtures/damsAssembledCollection.rdf.xml').read
      @damsAssembledCollection.save!
      @damsAssembledCollection.reload
      loadedAssembledCollection = DamsAssembledCollection.find(@damsAssembledCollection.pid)
      loadedAssembledCollection.titleValue.should == "UCSD Electronic Theses and Dissertations"
    end
  end

  subject do
    DamsAssembledCollection.new pid: "bb03030303"
  end
  it "should load a complex object from RDF/XML file" do
    subject = DamsAssembledCollection.new(:pid=>'bb03030303')

    subject.damsMetadata.content = File.new('spec/fixtures/damsAssembledCollection.rdf.xml').read
    subject.titleValue.should == "UCSD Electronic Theses and Dissertations"
    subject.beginDate.should == ["2009-05-03"]
    solr_doc = subject.to_solr
    solr_doc["language_tesim"].should include "English"
    subject.scopeContentNote.first.pid.should == "bd1366006j"
    solr_doc["scopeContentNote_tesim"].should include "Linked scope content note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    solr_doc["scopeContentNote_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    solr_doc["note_tesim"].should include "http://library.ucsd.edu/ark:/20775/bb80808080"
    solr_doc["custodialResponsibilityNote_tesim"].should include "Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    solr_doc["preferredCitationNote_tesim"].should include "Linked preferred citation note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
  end

  it "should create valid xml" do
    subject.titleValue = "UCSD Electronic Theses and Dissertations"
    subject.title.first.name = "UCSD Electronic Theses and Dissertations"
    subject.beginDate = "2009-05-03"
    subject.scopeContentNote.build.value = "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    subject.scopeContentNote.first.displayLabel = "Scope and contents"
    subject.scopeContentNote.first.type = "scope_and_content"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#"
         xmlns:mads="http://www.loc.gov/mads/rdf/v1#">
<dams:AssembledCollection rdf:about="#{Rails.configuration.id_namespace}bb03030303">
    <dams:title>
<mads:Title>
  <mads:authoritativeLabel>UCSD Electronic Theses and Dissertations</mads:authoritativeLabel>
  <mads:elementList rdf:parseType="Collection">
    <mads:MainTitleElement>
      <mads:elementValue>UCSD Electronic Theses and Dissertations</mads:elementValue>
    </mads:MainTitleElement>
  </mads:elementList>
</mads:Title>
    </dams:title>
    <dams:date>
      <dams:Date>
        <dams:beginDate>2009-05-03</dams:beginDate>
      </dams:Date>
    </dams:date>
    <dams:scopeContentNote>
      <dams:ScopeContentNote>
        <dams:displayLabel>Scope and contents</dams:displayLabel>
        <dams:type>scope_and_content</dams:type>
        <rdf:value>Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs.</rdf:value>        
      </dams:ScopeContentNote>
    </dams:scopeContentNote>
  </dams:AssembledCollection>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
