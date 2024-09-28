ENV['BOOTSNAP_CACHE_DIR'] = '/app/tmp/bootsnap'

require "bootsnap/setup"
Bootsnap.setup(
  cache_dir:            '/app/tmp/bootsnap', # この行を追加
  development_mode:     ENV['RAILS_ENV'] == 'development',
  load_path_cache:      true,
  compile_cache_iseq:   true,
  compile_cache_yaml:   true
)
