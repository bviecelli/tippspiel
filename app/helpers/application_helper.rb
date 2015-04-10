# -*- encoding : utf-8 -*-
module ApplicationHelper

  # angepasste devise Methode
  def custom_devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.join('<br/>')
    html = <<-HTML
      <div id='error_explanation' class='alert alert-error'>
        #{messages}
      </div>
    HTML

    html.html_safe
  end

  # controllername, path, needs_login
  def main_nav_items
    [
            ['main', root_path, false],
            ['tipps', tipps_path, true],
            ['tipps_for_phone', tipps_path({:for_phone => true}), true], # hat extra Behandlung in def write_main_nav - Extra Link auf dem Phone
            ['ranking', ranking_path, true],
            ['notice', notice_path, true],
            ['help', help_path, false]
    ]

  end

  def icon_with_text(icon_name, text='dummytext', add_on_ccs_class='')
    icon_name.present? ? "<i class='fi-#{icon_name} #{add_on_ccs_class}'></i>".html_safe + ' ' + text : text
  end

  def get_title
    "#{TOURNAMENT_NAME} #{t('app_name')}"
  end

  def write_team_with_flag(team_name, country_code='', spacer=nil)
    if country_code.present?
      haml_tag 'span.f16' do
        haml_tag "i.flag.#{country_code}"
      end
    end
    haml_concat spacer if spacer.present?
    haml_concat team_name
  end

  def default_sidebar_content
    # im Fehlerfall wird keine Sidebar angezeigt
    unless controller.controller_name == 'main' && controller.action_name == 'error'
      if current_user.present?
        haml_concat render_cell(:user_sidebar_links, :show)
        haml_concat render_cell(:sidebar_notes, :show, :item_count => 5, :last_updated_at => Notice.last_updated_at)
      end
      haml_concat render_cell(:rss_feed, :show, :item_count => 5)
      haml_concat render_cell(:extern_links, :show)
    end
  end

  def write_flash_messages
    if flash[:error].present?
      haml_tag 'p.error' do
        haml_tag 'div.alert.alert-error' do
          haml_tag 'a.close', {"data-dismiss"=>"alert"}, "×"
          haml_concat flash[:error]
        end
      end
    end
    if flash[:alert].present?
      haml_tag 'p.error' do
        haml_tag 'div.alert.alert-error' do
          haml_tag 'a.close', {"data-dismiss"=>"alert"}, "×"
          haml_concat flash[:alert]
        end
      end
    end
    if flash[:notice].present?
      haml_tag 'p.notice' do
        haml_tag 'div.alert.alert-success' do
          haml_tag 'a.close', {"data-dismiss"=>"alert"}, "×"
          haml_concat flash[:notice]
        end
      end
    end

    flash.discard
  end

  def write_navbar
    # TODO soeren 08.04.15 optimieren #92
    # 1. Navbar ist hidden-for-small-only: Also sichtbar auf Tablett und groesser
    # 2. Navbar ist visible-for-small-only: Off-Canvas Menu

    haml_tag 'div.contain-to-grid' do

      # 1.
      haml_tag 'nav.top-bar.hidden-for-small-only', {data: {topbar: ''}, role: 'navigation'} do
        haml_tag 'ul.title-area' do
          haml_tag 'li.name' do
            haml_tag :h1 do
              haml_tag 'a.brand', {:href=> '/'} do
                haml_concat image_tag('soccer_ball.png', :class=>'soccer_ball')
                haml_concat get_title
                if FEATURE_BETA_TEXT.present?
                  haml_tag 'small.label.warning.round', 'BETA'
                end
              end
            end
          end
          haml_tag 'li.toggle-topbar.menu-icon' do
            haml_tag 'a', {href: "#"} do
              haml_tag :span, ''
            end
          end
        end

        haml_tag 'section.top-bar-section' do
          haml_tag 'ul.right' do
            write_main_nav('right')
            write_auth_nav('right')
          end

          haml_tag 'ul.left' do
            # wenn man links auch ein Menue haben will
          end
        end
      end

      # 2.
      haml_tag 'div.visible-for-small-only' do
        haml_tag 'nav.tab-bar' do
          haml_tag 'section.left-small' do
            haml_tag 'a.left-off-canvas-toggle.menu-icon', {href: '#'} do
              haml_tag :span, ''
            end
          end

          haml_tag 'section.middle.tab-bar-section' do
            haml_tag 'h1.left' do
              haml_tag 'a.brand', {:href=> '/'} do
                haml_concat image_tag('soccer_ball.png', :class=>'soccer_ball')
                haml_concat get_title
                if FEATURE_BETA_TEXT.present?
                  haml_tag 'small.label.warning.round', 'BETA'
                end
              end
            end
          end
        end

        haml_tag 'nav.left-off-canvas-menu' do
          haml_tag 'ul.off-canvas-list' do
            write_main_nav('')
            write_auth_nav('')  # FIXME soeren 09.04.15 #92 passt so nicht ganz
          end
        end

      end

    end

  end

  def write_main_nav(ul_class)
    nav_items = main_nav_items

    unless user_signed_in?
      nav_items = main_nav_items.select{|i| i[2] == false}
    end

    if nav_items.present?
      nav_items.each do |key, path, needs_login|
        class_name = key == controller.controller_name ? 'active' : ''

        # TODO soeren 19.05.14 besser machen mit Rails4 #72 besser machen
        # Tipp Link wird 2 mal angegeben, einmal fuer Phone und der andere fuer Tablet und Desktop
        if key == 'tipps'
          haml_tag "li.#{class_name}.hidden-for-small-only" do
            haml_concat link_to(t(key), path)
          end
        elsif key == 'tipps_for_phone'
          haml_tag "li.#{class_name}.visible-for-small-only" do
            haml_concat link_to(t(key), path)
          end
        else
          haml_tag "li.#{class_name}" do
            haml_concat link_to(t(key), path)
          end
        end
      end
    end
  end

  def write_auth_nav(ul_class)
    if user_signed_in?
      haml_tag 'li.divider'
      sub_menu_id = MAIN_NAV_ITEM_CURRENT_USER_SUBMENU_ID
      css_class = (controller_name == 'user')  ? 'active' : ""
      sub_menu = get_main_subnavigation_array
      nav_text = get_user_name_or_sign_in_link
      if sub_menu[sub_menu_id].present?
        write_sub_menu(sub_menu_id, sub_menu[sub_menu_id][:links], nav_text, css_class)
      end
    end  # no else
  end

  def write_sub_menu(sub_menu_id, links, main_menu_text, css_class='')
    if sub_menu_id.present? && links.present? && main_menu_text.present?
      haml_tag "li##{sub_menu_id}.has-dropdown.#{css_class}" do

        haml_tag :a,  main_menu_text
        haml_tag 'ul.dropdown' do
          links.each do |link|
            if link[:divider].present?
              haml_tag 'li.divider'
            else
              haml_tag :li do
                haml_concat link_to(link[:text], link[:url])
              end
            end
          end
        end

      end
    end
  end

  # main subnavigation
    def get_main_subnavigation_array
      result = {}
      result[MAIN_NAV_ITEM_CURRENT_USER_SUBMENU_ID] =
          {:links => [
              {:text => t(:password_change), :url => user_edit_password_path},
              {:divider => true},
              {:text => icon_with_text('x-circle', t(:sign_out), 'icon'), :url => logout_path}
          ]}

      result
    end


  def get_user_name_or_sign_in_link
    if user_signed_in?
      hello_user_name
    else
      link_to(t(:sign_up), new_user_registration_path)
    end
  end

  def hello_user_name
    "#{t(:signed_in_hello)} #{current_user.firstname}"
  end



  # https://github.com/plataformatec/devise/wiki/How-To:-Display-a-custom-sign_in-form-anywhere-in-your-app
  def resource_name
    :user
  end
  def resource
    @resource ||= User.new
  end
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def write_footer_content
     haml_tag :p do
       haml_concat "© " + Time.now.strftime("%Y")
       haml_concat link_to("Sören Mothes", "http://www.soemo.org/")
       haml_concat " | "
       haml_concat link_to(t(:imprint), help_path + "#imprint")
       haml_concat " |  version #{$TIPPSPIEL_VERSION} - #{$TIPPSPIEL_BUILD_DATE}"
     end
  end

end
