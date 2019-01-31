#
#  Kubernetes (kubectl)
#
# Kubernetes is an open-source system for deployment, scaling,
# and management of containerized applications.
# Link: https://kubernetes.io/

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_KUBECONTEXT_SHOW="${SPACESHIP_KUBECONTEXT_SHOW=true}"
SPACESHIP_KUBECONTEXT_PREFIX="${SPACESHIP_KUBECONTEXT_PREFIX="at "}"
SPACESHIP_KUBECONTEXT_SUFFIX="${SPACESHIP_KUBECONTEXT_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_KUBECONTEXT_SYMBOL="${SPACESHIP_KUBECONTEXT_SYMBOL="☸️ "}"
SPACESHIP_KUBECONTEXT_COLOR="${SPACESHIP_KUBECONTEXT_COLOR="cyan"}"
SPACESHIP_KUBECONTEXT_NAMESPACE_SHOW="${SPACESHIP_KUBECONTEXT_NAMESPACE_SHOW=true}"
SPACESHIP_KUBECONTEXT_COLOR_GROUPS=(${SPACESHIP_KUBECONTEXT_COLOR_GROUPS=})

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_async_job_load_kubecontext() {
  [[ $SPACESHIP_KUBECONTEXT_SHOW == false ]] && return

  async_job spaceship spaceship_async_job_kubecontext
}

spaceship_async_job_kubecontext() {
  local kube_context=$(kubectl config current-context 2>/dev/null)
  [[ -z $kube_context ]] && return

  if [[ $SPACESHIP_KUBECONTEXT_NAMESPACE_SHOW == true ]]; then
    local kube_namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    [[ -n $kube_namespace && "$kube_namespace" != "default" ]] && kube_context="$kube_context ($kube_namespace)"
  fi

  echo "$kube_context"
}

# Show current context in kubectl
spaceship_kubecontext() {
  [[ -z "${SPACESHIP_ASYNC_RESULTS[spaceship_async_job_kubecontext]}" ]] && return

  # Apply custom color to section if value matches a pattern defined in SPACESHIP_KUBECONTEXT_COLOR_GROUPS array.
  # See Options.md for usage example.
  local len=${#SPACESHIP_KUBECONTEXT_COLOR_GROUPS[@]}
  local it_to=$((len / 2))
  local 'section_color' 'i'
  for ((i = 1; i <= $it_to; i++)); do
    local idx=$(((i - 1) * 2))
    local color="${SPACESHIP_KUBECONTEXT_COLOR_GROUPS[$idx + 1]}"
    local pattern="${SPACESHIP_KUBECONTEXT_COLOR_GROUPS[$idx + 2]}"
    if [[ "${SPACESHIP_ASYNC_RESULTS[spaceship_async_job_kubecontext]}" =~ "$pattern" ]]; then
      section_color=$color
      break
    fi
  done
  [[ -z "$section_color" ]] && section_color=$SPACESHIP_KUBECONTEXT_COLOR

  spaceship::section \
    "$section_color" \
    "$SPACESHIP_KUBECONTEXT_PREFIX" \
    "${SPACESHIP_KUBECONTEXT_SYMBOL}${SPACESHIP_ASYNC_RESULTS[spaceship_async_job_kubecontext]}" \
    "$SPACESHIP_KUBECONTEXT_SUFFIX"
}
