require 'spec_helper'

describe DamsProvenanceCollectionPart do

  before do
    @damsProvenanceCollectionPart = DamsProvenanceCollectionPart.new pid: "bb25252525"
  end

  it "should have the specified datastreams" do
    @damsProvenanceCollectionPart.datastreams.keys.should include("damsMetadata")
    @damsProvenanceCollectionPart.damsMetadata.should be_kind_of DamsProvenanceCollectionPartDatastream
  end

  it "should create/update a title" do
    @damsProvenanceCollectionPart.title.build
    @damsProvenanceCollectionPart.titleValue = "Dams Provenance Collection Part Title 1"
    @damsProvenanceCollectionPart.titleValue.should == "Dams Provenance Collection Part Title 1"

    @damsProvenanceCollectionPart.titleValue = "Dams Provenance Collection Part Title 2"
    @damsProvenanceCollectionPart.titleValue.should == "Dams Provenance Collection Part Title 2"
  end

  it "should create/update a subject" do
    @damsProvenanceCollectionPart.topic.build
    @damsProvenanceCollectionPart.topic.first.name = "topic 1"
    @damsProvenanceCollectionPart.topic.first.name.should == ["topic 1"]
    @damsProvenanceCollectionPart.topic << MadsTopic.new( :name => "topic 2" )
    pending "should be able to access second and subsequent topics..."
    @damsProvenanceCollectionPart.topic[1].name.should == ["topic 2"]

    @damsProvenanceCollectionPart.topic.first.name = "topic 3"
    @damsProvenanceCollectionPart.topic.first.name.should == ["topic 3"]
    @damsProvenanceCollectionPart.topic.second.name = "topic 4"
    @damsProvenanceCollectionPart.topic.second.name.should == ["topic 4"]
  end

  subject do
    DamsProvenanceCollectionPart.new pid: "bb25252525"
  end
  it "should load a complex object from RDF/XML file" do
    subject = DamsProvenanceCollectionPart.new(:pid=>'bb25252525')

    subject.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollectionPart.rdf.xml').read
    subject.titleValue.should == "May 2009"
    subject.beginDate.should == ["2009-05-03"]
    subject.endDate.should == ["2009-05-31"]
    subject.language.first.pid.should == "bd0410344f"
    solr_doc = subject.to_solr
    solr_doc["scopeContentNote_tesim"].should include "Linked scope content note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    solr_doc["scopeContentNote_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    subject.note.first.pid.should == "bd52568274"
    solr_doc["note_tesim"].should include "Linked note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    solr_doc["note_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    solr_doc["note_tesim"].should include "http://library.ucsd.edu/ark:/20775/bb80808080"
    solr_doc["note_tesim"].should include "Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    solr_doc["note_tesim"].should include "Linked preferred citation note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
  end  

  it "should create valid xml" do
    subject.titleValue = "May 2009"
    subject.title.first.name = "May 2009"
    subject.beginDate = "2009-05-03"
    subject.endDate = "2009-05-31"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#"
         xmlns:mads="http://www.loc.gov/mads/rdf/v1#">
  <dams:ProvenanceCollectionPart rdf:about="#{Rails.configuration.id_namespace}bb25252525">
    <dams:title>
      <mads:Title>
        <mads:authoritativeLabel>May 2009</mads:authoritiativeLabel>
        <mads:elementList rdf:parseType="Collection">
          <mads:MainTitleElement>
            <mads:elementValue>May 2009</mads:elementValue>
          </mads:MainTitleElement>
         </mads:elementList>
      </mads:Title>
    </dams:title>
    <dams:date>
      <dams:Date>
        <dams:beginDate>2009-05-03</dams:beginDate>
        <dams:endDate>2009-05-31</dams:endDate>
      </dams:Date>
    </dams:date>
  </dams:ProvenanceCollectionPart>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
