require 'spec_helper'

describe DamsProvenanceCollection do

  before do
    @damsProvenanceCollection = DamsProvenanceCollection.new pid: "bb24242424"
  end

  it "should have the specified datastreams" do
    @damsProvenanceCollection.datastreams.keys.should include("damsMetadata")
    @damsProvenanceCollection.damsMetadata.should be_kind_of DamsProvenanceCollectionDatastream
  end

  it "should create/update a form" do
    @damsProvenanceCollection.title.build
    @damsProvenanceCollection.titleValue = "title"
    @damsProvenanceCollection.titleValue.should == "title"

    @damsProvenanceCollection.subtitle = "subtitle"
    @damsProvenanceCollection.subtitle.should == "subtitle"
    
    @damsProvenanceCollection.titlePartName = "titlePartName"
    @damsProvenanceCollection.titlePartName.should == "titlePartName"

    @damsProvenanceCollection.titleNonSort = "titleNonSort"
    @damsProvenanceCollection.titleNonSort.should == "titleNonSort"

    @damsProvenanceCollection.dateValue = "2013-07-25"
    @damsProvenanceCollection.dateValue.should == ["2013-07-25"]

    @damsProvenanceCollection.beginDate = "2009-05-03"
    @damsProvenanceCollection.beginDate.should == ["2009-05-03"]

    @damsProvenanceCollection.endDate = "2010-06-30"
    @damsProvenanceCollection.endDate.should == ["2010-06-30"]

    @damsProvenanceCollection.languageURI = "Test Language"
    @damsProvenanceCollection.languageURI.should == "#{Rails.configuration.id_namespace}Test Language"

    @damsProvenanceCollection.noteValue = "noteValue"
    @damsProvenanceCollection.noteValue.should == ["noteValue"]

    @damsProvenanceCollection.noteType =  "noteType"
    @damsProvenanceCollection.noteType.should == ["noteType"]

    @damsProvenanceCollection.noteDisplayLabel = "noteDisplayLabel"
    @damsProvenanceCollection.noteDisplayLabel.should == ["noteDisplayLabel"]

    @damsProvenanceCollection.scopeContentNoteValue = "scopeContentNoteValue"
    @damsProvenanceCollection.scopeContentNoteValue.should == ["scopeContentNoteValue"]

    @damsProvenanceCollection.scopeContentNoteType = "scopeContentNoteType"
    @damsProvenanceCollection.scopeContentNoteType.should == ["scopeContentNoteType"]

    # @damsProvenanceCollection.relationshipRoleURI = "relationshipRoleURI"
    # @damsProvenanceCollection.relationshipRoleURI.should == [#<MadsAuthorityInternal:0x007fda6f77e790 @graph=#<RDF::Repository:0x3fed3669964c()>, @rdf_subject=#<RDF::URI:0x3fed37bb6bec(http://library.ucsd.edu/ark:/20775/relationshipRoleURI)>>]

    @damsProvenanceCollection.relationshipNameType = ["ConferenceName"]
    @damsProvenanceCollection.relationshipNameType.should == ["ConferenceName"]

    @damsProvenanceCollection.subjectType = ["ConferenceName"]
    @damsProvenanceCollection.subjectType.should == ["ConferenceName"]

    @damsProvenanceCollection.subjectURI = ["subjectURI"]
    @damsProvenanceCollection.subjectURI.should == "#{Rails.configuration.id_namespace}subjectURI"

    @damsProvenanceCollection.relatedResourceType = "relatedResourceType"
    @damsProvenanceCollection.relatedResourceType.should == ["relatedResourceType"]

    @damsProvenanceCollection.relatedResourceUri = "relatedResourceUri"
    @damsProvenanceCollection.relatedResourceUri.should == ["relatedResourceUri"]

    @damsProvenanceCollection.relatedResourceDescription = "relatedResourceDescription"
    @damsProvenanceCollection.relatedResourceDescription.should == ["relatedResourceDescription"]
  end

  describe "Store to a repository" do
    before do
      MadsPersonalName.create! pid: "zzXXXXXXX1", name: "Maria", externalAuthority: "someUrl"
    end
    after do
      #@damsProvenanceCollection.delete
    end
    it "should store/retrieve from a repository" do
      @damsProvenanceCollection.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection.rdf.xml').read
      @damsProvenanceCollection.save!
      @damsProvenanceCollection.reload
      loadedProvenanceCollection = DamsProvenanceCollection.find(@damsProvenanceCollection.pid)
      loadedProvenanceCollection.titleValue.should == "Historical Dissertations"
      loadedProvenanceCollection.beginDate.should == "2009-05-03"
      loadedProvenanceCollection.endDate.should == "2010-06-30"
      loadedProvenanceCollection.language.first.pid.should == "bd0410344f"
      loadedProvenanceCollection.scopeContentNote.first.pid.should == "bd1366006j"
      loadedProvenanceCollection.note.first.pid.should == "bd52568274"
      loadedProvenanceCollection.custodialResponsibilityNote.first.pid.should == "bd9113515d"
      loadedProvenanceCollection.preferredCitationNote.first.pid.should == "bd3959888k"
      loadedProvenanceCollection.relationship.first.role.first.pid.should == "bd55639754"
      loadedProvenanceCollection.relationship.first.name.first.pid.should == "bb08080808"
      loadedProvenanceCollection.part_node.first.should == "#{Rails.configuration.id_namespace}bb25252525"
      loadedProvenanceCollection.event.first.pid.should == "bb29292929"
    end
  end

  subject do
    DamsProvenanceCollection.new pid: 'bb24242424'
  end
  it "should load a complex object from RDF/XML file" do
    subject = DamsProvenanceCollection.new(:pid=>'bb24242424')

    subject.damsMetadata.content = File.new('spec/fixtures/damsProvenanceCollection.rdf.xml').read
    subject.titleValue.should == "Historical Dissertations"
    subject.beginDate.should == "2009-05-03"
    subject.endDate.should == "2010-06-30"
    subject.language.first.pid.should == "bd0410344f"
    subject.scopeContentNote.first.pid.should == "bd1366006j"
    subject.note.first.pid.should == "bd52568274"
    subject.custodialResponsibilityNote.first.pid.should == "bd9113515d"
    subject.preferredCitationNote.first.pid.should == "bd3959888k"
    subject.relationship.first.role.first.pid.should == "bd55639754"
    subject.relationship.first.name.first.pid.should == "bb08080808"
    subject.part_node.first.should == "#{Rails.configuration.id_namespace}bb25252525"
    subject.event.first.pid.should == "bb29292929"
  end

  subject do
    DamsProvenanceCollection.new pid: "bb24242424"
  end
  it "should create valid xml" do
    subject.titleValue = "Historical Dissertations"
    subject.title.first.name = "Historical Dissertations"
    subject.beginDate = "2009-05-03"
    subject.endDate = "2010-06-30"
    subject.languageURI = ["bd0410344f"]

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
  <dams:language rdf:resource="http://library.ucsd.edu/ark:/20775/bd0410344f"/>   
  </dams:ProvenanceCollection>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
