## deploy: deploy the app to production
.PHONY: deploy
deploy:
	@read -p "Enter commit message: " MESSAGE; \
	flutter build web && \
	rsync -av --exclude='.git' --exclude='.last_build_id' --delete ./build/web/ ../push_swap_it_build/ && \
	cd ../push_swap_it_build && \
	git add . && \
	git commit -m "$$MESSAGE" && \
	git push && \
	cd ../push_swap_it