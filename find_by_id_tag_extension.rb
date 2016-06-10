require "radiant-find_by_id_tag-extension"

class FindByIdTagExtension < Radiant::Extension
  version     RadiantFindByIdTagExtension::VERSION
  description RadiantFindByIdTagExtension::DESCRIPTION
  url         RadiantFindByIdTagExtension::URL

  def activate
    Page.send :include, FindById::TagExtension
    
    admin.pages.index.add :sitemap_head, "id_column_th", :before => "title_column_header"
    admin.pages.index.add :node, "id_column_td", :before => "title_column"
    admin.pages.edit.add :main, "id_field", :before => "edit_form"
    
  end
end
