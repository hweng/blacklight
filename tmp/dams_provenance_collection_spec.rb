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
    subject.language.first.pid.should == "bd0410344f"
    solr_doc = subject.to_solr
    solr_doc["language_tesim"].should include "English"
    solr_doc["scopeContentNote_tesim"].should include "Linked scope content note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    solr_doc["scopeContentNote_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    subject.note.first.pid.should == "bd52568274"
    solr_doc["note_tesim"].should include "Linked note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    solr_doc["note_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    solr_doc["note_tesim"].should include "http://library.ucsd.edu/ark:/20775/bb80808080"
    solr_doc["note_tesim"].should include "Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    solr_doc["note_tesim"].should include "Linked preferred citation note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
  end  

  it "should load a complex object from XML file" do
    subject = DamsProvenanceCollection.new(:pid=>'bd48133407')

    subject.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection.xml').read
    subject.titleValue.should == "Sample Provenance Collection"
    subject.language.first.pid.should == "bd0410344f"
    solr_doc = subject.to_solr
    solr_doc["personalName_tesim"].should include "Smith, John, Dr., 1965-"
    solr_doc["language_tesim"].should include "English"
    solr_doc["geographic_tesim"].should include "mads:Geographic value"
    solr_doc["iconography_tesim"].should include "dams:Iconography value"
    solr_doc["note_tesim"].should include "http://library.ucsd.edu/ark:/20775/bd48133407"
    solr_doc["note_tesim"].should include "1 digital object."
    solr_doc["note_tesim"].should include "CustodialResponsibilityNote value"
    solr_doc["note_tesim"].should include "PreferredCitationNote value"
    solr_doc["note_tesim"].should include "ScopeContentNote value"
    solr_doc["occupation_tesim"].should include "mads:Occupation value"
    solr_doc["conferenceName_tesim"].should include "mads:ConferenceName value"
    solr_doc["genreForm_tesim"].should include "mads:GenreForm value"
    solr_doc["builtWorkPlace_tesim"].should include "dams:BuiltWorkPlace value"
    solr_doc["corporateName_tesim"].should include "mads:CorporateName value"
    solr_doc["function_tesim"].should include "dams:Function value"
    solr_doc["date_tesim"].should include "Easter 2012"
    solr_doc["date_tesim"].should include "2012-04-08"
    solr_doc["date_tesim"].should include "2012-04-08"
    solr_doc["preferredCitationNote_tesim"].should include "PreferredCitationNote value"
    solr_doc["temporal_tesim"].should include "mads:Temporal value"
    solr_doc["culturalContext_tesim"].should include "dams:CulturalContext value"
    solr_doc["topic_tesim"].should include "mads:Topic value"
    solr_doc["custodialResponsibilityNote_tesim"].should include "CustodialResponsibilityNote value"
    solr_doc["stylePeriod_tesim"].should include "dams:StylePeriod value"
    solr_doc["complexSubject_tesim"].should include "mads:Topic value--mads:Temporal value"
    solr_doc["topic_tesim"].should include "mads:Topic value"
    solr_doc["temporal_tesim"].should include "mads:Temporal value"
    solr_doc["technique_tesim"].should include "mads:Technique value"
    solr_doc["title_tesim"].should include "Sample Provenance Collection, The: Subtitle, Allegro, 1"
    solr_doc["scientificName_tesim"].should include "dams:ScientificName value"
    solr_doc["familyName_tesim"].should include "mads:FamilyName value"
    solr_doc["name_tesim"].should include "mads:Name value"
    solr_doc["scopeContentNote_tesim"].should include "ScopeContentNote value"

    # solr_doc["scopeContentNote_tesim"].should include "Linked scope content note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    # solr_doc["scopeContentNote_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    # subject.note.first.pid.should == "bd52568274"
    # solr_doc["note_tesim"].should include "Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    # solr_doc["note_tesim"].should include "http://library.ucsd.edu/ark:/20775/bb80808080"
    # solr_doc["note_tesim"].should include "Linked custodial responsibility note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
    # solr_doc["note_tesim"].should include "Linked preferred citation note: Electronic theses and dissertations submitted by UC San Diego students as part of their degree requirements and representing all UC San Diego academic programs."
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