require 'spec_helper'

describe DamsProvenanceCollection do

  before do
    @damsProvenanceCollections = DamsProvenanceCollection.new pid: "bb24242424"
  end

  it "should have the specified datastreams" do
    @damsProvenanceCollections.datastreams.keys.should include("damsMetadata")
    @damsProvenanceCollections.damsMetadata.should be_kind_of DamsProvenanceCollectionDatastream
  end

  it "should create/update a title" do
    @damsProvenanceCollections.title.build
    #@damsProvenanceCollections.titleValue.should == []
    @damsProvenanceCollections.titleValue = "Dams Provenance Collection Title 1"
    @damsProvenanceCollections.titleValue.should == "Dams Provenance Collection Title 1"
  
    @damsProvenanceCollections.titleValue = "Dams Provenance Collection Title 2"
    @damsProvenanceCollections.titleValue.should == "Dams Provenance Collection Title 2"
  end

  it "should create/update a subject" do
    @damsProvenanceCollections.topic.build
    @damsProvenanceCollections.topic.first.name = "topic 1"
    @damsProvenanceCollections.topic.first.name.should == ["topic 1"]
    @damsProvenanceCollections.topic << MadsTopic.new( :name => "topic 2" )
    pending "should be able to access second and subsequent topics..."
    @damsProvenanceCollections.topic[1].name.should == ["topic 2"]

    @damsProvenanceCollections.topic.first.name = "topic 3"
    @damsProvenanceCollections.topic.first.name.should == ["topic 3"]
    @damsProvenanceCollections.topic.second.name = "topic 4"
    @damsProvenanceCollections.topic.second.name.should == ["topic 4"]
  end

  subject do
    DamsProvenanceCollection.new pid: 'bb24242424'
  end
  it "should load a complex object from RDF/XML file" do
    subject = DamsProvenanceCollection.new(:pid=>'bb24242424')

    subject.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection.rdf.xml').read
    subject.titleValue.should == "Historical Dissertations"
  end
  
  subject do
    DamsProvenanceCollection.new pid: "bb24242424"
  end
  it "should create valid xml" do
    subject.titleValue = "Historical Dissertations"
    subject.title.first.name = "Historical Dissertations"
    subject.beginDate = "2009-05-03"
    subject.endDate = "2010-06-30"
    xml =<<END
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:dams="http://library.ucsd.edu/ontology/dams#"
         xmlns:mads="http://www.loc.gov/mads/rdf/v1#">
  <dams:ProvenanceCollection rdf:about="#{Rails.configuration.id_namespace}bb24242424">
    <dams:title>
      <mads:Title>
        <mads:authoritativeLabel>Historical Dissertations</mads:authoritativeLabel>
        <mads:elementList rdf:parseType="Collection">
          <mads:MainTitleElement>
            <mads:elementValue>Historical Dissertations</mads:elementValue>
          </mads:MainTitleElement>
        </mads:elementList>
      </mads:Title>
    </dams:title>
    <dams:date>
      <dams:Date>
        <dams:beginDate>2009-05-03</dams:beginDate>
        <dams:endDate>2010-06-30</dams:endDate>    
      </dams:Date>
    </dams:date>
  </dams:ProvenanceCollection>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
