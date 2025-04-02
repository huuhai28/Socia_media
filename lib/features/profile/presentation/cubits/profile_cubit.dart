// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_socia_media/features/profile/domain/entities/profile_user.dart';
import 'package:project_socia_media/features/profile/domain/repos/profile_repo.dart';
import 'package:project_socia_media/features/profile/presentation/cubits/profile_state.dart';
import 'package:project_socia_media/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({
    required this.profileRepo,
    required this.storageRepo,
  }) : super(ProfileInitial());

  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // return user profile given uid -> useful for loading many profiles for posts

  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());
    try {
      // fetch current profile first
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profile update"));
        return;
      }

      // profile picture update
      String? imageDownloadUrl;

      // ensure there is an image
      if (imageWebBytes != null || imageMobilePath != null) {
        // for mobile
        if (imageMobilePath != null) {
          // upload
          imageDownloadUrl =
              await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
        }
        // for web
        else if (imageWebBytes != null) {
          imageDownloadUrl =
              await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError("Failed to upload image"));
          return;
        }
      }
      // new profile
      final ProfileUser updatedProfile = currentUser.copyWith(
          newBio: newBio ?? currentUser.bio,
          newProfileImageUrl: imageDownloadUrl);

      // update in repo in FireBase
      await profileRepo.updateProfile(updatedProfile);

      emit(ProfileLoaded(updatedProfile));
    } catch (e, stackTrace) {
      print("Error: $e");
      print("StackTrace: $stackTrace");
      emit(ProfileError(e.toString()));
    }
  }

  // toggle follow/unfollow
  Future<void> toggleFollow(
      String currentUserId, String targetUserID, bool setIsFollow) async {
    try {
      await profileRepo.toggleFollow(currentUserId, targetUserID, setIsFollow);
    } catch (e) {
      emit(ProfileError("Error toggling follow: $e"));
    }
  }
}
