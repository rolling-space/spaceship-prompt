#@IgnoreInspection BashAddShebang
#
# Ruby
#
# A dynamic, reflective, object-oriented, general-purpose programming language.
# Link: https://www.ruby-lang.org/

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_RBENV_GMS_SHOW="${SPACESHIP_RBENV_GMS_SHOW=true}"
SPACESHIP_RBENV_GMS_PREFIX="${SPACESHIP_RBENV_GMS_PREFIX=""}"
SPACESHIP_RBENV_GMS_SUFFIX="${SPACESHIP_RBENV_GMS_SUFFIX=""}"
SPACESHIP_RBENV_GMS_SYMBOL="${SPACESHIP_RBENV_GMS_SYMBOL="\uf9cb"}"
SPACESHIP_RBENV_GMS_COLOR="${SPACESHIP_RBENV_GMS_COLOR="blue"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show current version of Ruby
spaceship_async_job_load_rbenv_gms() {
  [[ $SPACESHIP_RBENV_GMS_SHOW == false ]] && return

  async_job spaceship spaceship_async_job_rbenv_gms
}

spaceship_async_job_rbenv_gms() {
  # Show versions only for Ruby-specific folders
#  [[ -f Gemfile || -f Rakefile || -f Thorfile || -n *.ruby-version(#qN^/) || -n *.rbenv-gemsets(#qN^/) ]] || return

  local rbenv_gemsets
  if spaceship::exists rbenv-gemset; then
    rbenv_gemsets=$(rbenv gemset active)
  else
    return
  fi

#  [[ -z $ruby_version || "${ruby_version}" == "system" ]] && return

  # Add 'v' before ruby version that starts with a number
  rbenv_gemsets="${rbenv_gemsets}"

  echo $rbenv_gemsets
}

spaceship_rbenv_gms() {
  [[ -z "${SPACESHIP_ASYNC_RESULTS[spaceship_async_job_rbenv_gms]}" ]] && return

  spaceship::section \
    "$SPACESHIP_RBENV_GMS_COLOR" \
    "$SPACESHIP_RBENV_GMS_PREFIX" \
    "${SPACESHIP_RBENV_GMS_SYMBOL}${SPACESHIP_ASYNC_RESULTS[spaceship_async_job_rbenv_gms]}" \
    "$SPACESHIP_RBENV_GMS_SUFFIX"
}
