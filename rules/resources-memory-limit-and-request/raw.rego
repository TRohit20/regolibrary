package armo_builtins

#  ================================== no memory limits ==================================
# Fails if pod does not have container with memory-limits
deny[msga] {
	pod := input[_]
	pod.kind == "Pod"
	container := pod.spec.containers[i]
	not container.resources.limits.memory
	fixPaths := [{"path": sprintf("spec.containers[%v].resources.limits.memory", [format_int(i, 10)]), "value": "YOUR_VALUE"}]

	msga := {
		"alertMessage": sprintf("Container: %v does not have memory-limit or request", [container.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"fixPaths": fixPaths,
		"failedPaths": [],
		"alertObject": {"k8sApiObjects": [pod]},
	}
}

# Fails if workload does not have container with memory-limits
deny[msga] {
	wl := input[_]
	spec_template_spec_patterns := {"Deployment", "ReplicaSet", "DaemonSet", "StatefulSet", "Job"}
	spec_template_spec_patterns[wl.kind]
	container := wl.spec.template.spec.containers[i]
	not container.resources.limits.memory
	fixPaths := [{"path": sprintf("spec.template.spec.containers[%v].resources.limits.memory", [format_int(i, 10)]), "value": "YOUR_VALUE"}]

	msga := {
		"alertMessage": sprintf("Container: %v in %v: %v   does not have memory-limit or request", [container.name, wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"fixPaths": fixPaths,
		"failedPaths": [],
		"alertObject": {"k8sApiObjects": [wl]},
	}
}

# Fails if cronjob does not have container with memory-limits
deny[msga] {
	wl := input[_]
	wl.kind == "CronJob"
	container = wl.spec.jobTemplate.spec.template.spec.containers[i]
	not container.resources.limits.memory
	fixPaths := [{"path": sprintf("spec.jobTemplate.spec.template.spec.containers[%v].resources.limits.memory", [format_int(i, 10)]), "value": "YOUR_VALUE"}]

	msga := {
		"alertMessage": sprintf("Container: %v in %v: %v   does not have memory-limit or request", [container.name, wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"fixPaths": fixPaths,
		"failedPaths": [],
		"alertObject": {"k8sApiObjects": [wl]},
	}
}

#  ================================== no memory requests ==================================
# Fails if pod does not have container with memory requests
deny[msga] {
	pod := input[_]
	pod.kind == "Pod"
	container := pod.spec.containers[i]
	not container.resources.requests.memory
	fixPaths := [{"path": sprintf("spec.containers[%v].resources.requests.memory", [format_int(i, 10)]), "value": "YOUR_VALUE"}]

	msga := {
		"alertMessage": sprintf("Container: %v does not have memory-limit or request", [container.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"fixPaths": fixPaths,
		"failedPaths": [],
		"alertObject": {"k8sApiObjects": [pod]},
	}
}

# Fails if workload does not have container with memory requests
deny[msga] {
	wl := input[_]
	spec_template_spec_patterns := {"Deployment", "ReplicaSet", "DaemonSet", "StatefulSet", "Job"}
	spec_template_spec_patterns[wl.kind]
	container := wl.spec.template.spec.containers[i]
	not container.resources.requests.memory
	fixPaths := [{"path": sprintf("spec.template.spec.containers[%v].resources.requests.memory", [format_int(i, 10)]), "value": "YOUR_VALUE"}]

	msga := {
		"alertMessage": sprintf("Container: %v in %v: %v   does not have memory-limit or request", [container.name, wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"fixPaths": fixPaths,
		"failedPaths": [],
		"alertObject": {"k8sApiObjects": [wl]},
	}
}

# Fails if cronjob does not have container with memory requests
deny[msga] {
	wl := input[_]
	wl.kind == "CronJob"
	container = wl.spec.jobTemplate.spec.template.spec.containers[i]
	not container.resources.requests.memory
	fixPaths := [{"path": sprintf("spec.jobTemplate.spec.template.spec.containers[%v].resources.requests.memory", [format_int(i, 10)]), "value": "YOUR_VALUE"}]

	msga := {
		"alertMessage": sprintf("Container: %v in %v: %v   does not have memory-limit or request", [container.name, wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"fixPaths": fixPaths,
		"failedPaths": [],
		"alertObject": {"k8sApiObjects": [wl]},
	}
}


# ============================================= memory requests exceed min/max =============================================

# Fails if pod exceeds memory request
deny[msga] {
	pod := input[_]
	pod.kind == "Pod"
	container := pod.spec.containers[i]
	memory_req := container.resources.requests.memory
	is_req_exceeded_memory(memory_req)
	path := "resources.requests.memory"

	failed_paths := sprintf("spec.containers[%v].%v", [format_int(i, 10), path])

	msga := {
		"alertMessage": sprintf("Container: %v exceeds memory request", [container.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"reviewPaths": [failed_paths],
		"failedPaths": [failed_paths],
		"fixPaths": [],
		"alertObject": {"k8sApiObjects": [pod]},
	}
}

# Fails if workload exceeds memory request
deny[msga] {
	wl := input[_]
	spec_template_spec_patterns := {"Deployment", "ReplicaSet", "DaemonSet", "StatefulSet", "Job"}
	spec_template_spec_patterns[wl.kind]
	container := wl.spec.template.spec.containers[i]

	memory_req := container.resources.requests.memory
	is_req_exceeded_memory(memory_req)
	path := "resources.requests.memory"

	failed_paths := sprintf("spec.template.spec.containers[%v].%v", [format_int(i, 10), path])

	msga := {
		"alertMessage": sprintf("Container: %v in %v: %v exceeds memory request", [container.name, wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"reviewPaths": [failed_paths],
		"failedPaths": [failed_paths],
		"fixPaths": [],
		"alertObject": {"k8sApiObjects": [wl]},
	}
}

# Fails if cronjob exceeds memory request
deny[msga] {
	wl := input[_]
	wl.kind == "CronJob"
	container = wl.spec.jobTemplate.spec.template.spec.containers[i]

	memory_req := container.resources.requests.memory
	is_req_exceeded_memory(memory_req)
	path := "resources.requests.memory" 

	failed_paths := sprintf("spec.jobTemplate.spec.template.spec.containers[%v].%v", [format_int(i, 10), path])

	msga := {
		"alertMessage": sprintf("Container: %v in %v: %v exceeds memory request", [container.name, wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"reviewPaths": [failed_paths],
		"failedPaths": [failed_paths],
		"fixPaths": [],
		"alertObject": {"k8sApiObjects": [wl]},
	}
}

# ============================================= memory limits exceed min/max =============================================

# Fails if pod exceeds memory-limit 
deny[msga] {
	pod := input[_]
	pod.kind == "Pod"
	container := pod.spec.containers[i]
	memory_limit := container.resources.limits.memory
	is_limit_exceeded_memory(memory_limit)
	path := "resources.limits.memory"

	failed_paths := sprintf("spec.containers[%v].%v", [format_int(i, 10), path])

	msga := {
		"alertMessage": sprintf("Container: %v exceeds memory-limit ", [container.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"reviewPaths": [failed_paths],
		"failedPaths": [failed_paths],
		"fixPaths": [],
		"alertObject": {"k8sApiObjects": [pod]},
	}
}

# Fails if workload exceeds memory-limit 
deny[msga] {
	wl := input[_]
	spec_template_spec_patterns := {"Deployment", "ReplicaSet", "DaemonSet", "StatefulSet", "Job"}
	spec_template_spec_patterns[wl.kind]
	container := wl.spec.template.spec.containers[i]

	memory_limit := container.resources.limits.memory
	is_limit_exceeded_memory(memory_limit)
	path := "resources.limits.memory"

	failed_paths := sprintf("spec.template.spec.containers[%v].%v", [format_int(i, 10), path])

	msga := {
		"alertMessage": sprintf("Container: %v in %v: %v exceeds memory-limit", [container.name, wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"reviewPaths": [failed_paths],
		"failedPaths": [failed_paths],
		"fixPaths": [],
		"alertObject": {"k8sApiObjects": [wl]},
	}
}

# Fails if cronjob exceeds memory-limit 
deny[msga] {
	wl := input[_]
	wl.kind == "CronJob"
	container = wl.spec.jobTemplate.spec.template.spec.containers[i]

	memory_limit := container.resources.limits.memory
	is_limit_exceeded_memory(memory_limit)
	path := "resources.limits.memory"

	failed_paths := sprintf("spec.jobTemplate.spec.template.spec.containers[%v].%v", [format_int(i, 10), path])

	msga := {
		"alertMessage": sprintf("Container: %v in %v: %v exceeds memory-limit", [container.name, wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"reviewPaths": [failed_paths],
		"failedPaths": [failed_paths],
		"fixPaths": [],
		"alertObject": {"k8sApiObjects": [wl]},
	}
}

######################################################################################################


is_limit_exceeded_memory(memory_limit) {
	is_min_limit_exceeded_memory(memory_limit)
}

is_limit_exceeded_memory(memory_limit) {
	is_max_limit_exceeded_memory(memory_limit)
}

is_req_exceeded_memory(memory_req) {
	is_max_request_exceeded_memory(memory_req)
}

is_req_exceeded_memory(memory_req) {
	is_min_request_exceeded_memory(memory_req)
}

# helpers

is_max_limit_exceeded_memory(memory_limit) {
	memory_limit_max := data.postureControlInputs.memory_limit_max[_]
	compare_max(memory_limit_max, memory_limit)
}

is_min_limit_exceeded_memory(memory_limit) {
	memory_limit_min := data.postureControlInputs.memory_limit_min[_]
	compare_min(memory_limit_min, memory_limit)
}

is_max_request_exceeded_memory(memory_req) {
	memory_req_max := data.postureControlInputs.memory_request_max[_]
	compare_max(memory_req_max, memory_req)
}

is_min_request_exceeded_memory(memory_req) {
	memory_req_min := data.postureControlInputs.memory_request_min[_]
	compare_min(memory_req_min, memory_req)
}

##############
# helpers

# Compare according to unit - max
compare_max(max, given) {
	endswith(max, "Mi")
	endswith(given, "Mi")
	split_max := split(max, "Mi")[0]
	split_given := split(given, "Mi")[0]
	split_given > split_max
}

compare_max(max, given) {
	endswith(max, "M")
	endswith(given, "M")
	split_max := split(max, "M")[0]
	split_given := split(given, "M")[0]
	split_given > split_max
}

compare_max(max, given) {
	endswith(max, "m")
	endswith(given, "m")
	split_max := split(max, "m")[0]
	split_given := split(given, "m")[0]
	split_given > split_max
}

compare_max(max, given) {
	not is_special_measure(max)
	not is_special_measure(given)
	given > max
}

################
# Compare according to unit - min
compare_min(min, given) {
	endswith(min, "Mi")
	endswith(given, "Mi")
	split_min := split(min, "Mi")[0]
	split_given := split(given, "Mi")[0]
	split_given < split_min
}

compare_min(min, given) {
	endswith(min, "M")
	endswith(given, "M")
	split_min := split(min, "M")[0]
	split_given := split(given, "M")[0]
	split_given < split_min
}

compare_min(min, given) {
	endswith(min, "m")
	endswith(given, "m")
	split_min := split(min, "m")[0]
	split_given := split(given, "m")[0]
	split_given < split_min
}

compare_min(min, given) {
	not is_special_measure(min)
	not is_special_measure(given)
	given < min
}

# Check that is same unit
is_special_measure(unit) {
	endswith(unit, "m")
}

is_special_measure(unit) {
	endswith(unit, "M")
}

is_special_measure(unit) {
	endswith(unit, "Mi")
}
