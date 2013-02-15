module BreadcrumbsHelper
   def breadcrumb_document(doc)
    format = document_partial_name(doc).upcase
    add_breadcrumb format, doc
  end

  
  def breadcrumb_for_catalog(opts={:label=>nil})
    query_params = session[:search] ? session[:search].dup : {}
    query_params.delete :counter
    query_params.delete :total
    add_breadcrumb "SEARCH RESULTS", url_for(query_params)
    link_url = url_for(query_params)
  end
end