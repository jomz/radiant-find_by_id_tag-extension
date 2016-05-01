require "radiant-find_by_id_tag-extension"

class FindByIdTagExtension < Radiant::Extension
  version     RadiantFindByIdTagExtension::VERSION
  description RadiantFindByIdTagExtension::DESCRIPTION
  url         RadiantFindByIdTagExtension::URL

  def activate
    Page.send :include, FindById::TagExtension
  end
end
