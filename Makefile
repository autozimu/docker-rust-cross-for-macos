build-image: Dockerfile
	docker build --tag autozimu/rust-cross-for-macos .

publish-image:
	docker push autozimu/rust-cross-for-macos
