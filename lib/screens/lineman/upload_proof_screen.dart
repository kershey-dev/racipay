import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/ticket_model.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/section_header.dart';

class UploadProofScreen extends StatefulWidget {
  final TicketModel ticket;

  const UploadProofScreen({
    super.key,
    required this.ticket,
  });

  @override
  State<UploadProofScreen> createState() => _UploadProofScreenState();
}

class _UploadProofScreenState extends State<UploadProofScreen> {
  bool _hasPhoto = false;
  bool _isLoading = false;
  final TextEditingController _noteController = TextEditingController();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _noteController.dispose();
    super.dispose();
  }

  void _selectPhotoFromCamera() {
    setState(() {
      _hasPhoto = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Camera will be available in the full version',
        ),
      ),
    );
  }

  void _selectPhotoFromGallery() {
    setState(() {
      _hasPhoto = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Gallery will be available in the full version',
        ),
      ),
    );
  }

  void _uploadProof() {
    if (!_hasPhoto || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Proof uploaded successfully!\n(Demo mode — real upload connects to backend)',
          ),
        ),
      );

      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Proof'),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Uploading proof for:',
                      style: TextStyle(
                        color: AppColors.textGray,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.ticket.ticketNumber,
                      style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.ticket.subscriberName,
                      style: const TextStyle(
                        color: AppColors.textGray,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildUploadArea(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectPhotoFromCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectPhotoFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('From Gallery'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Upload Notes (Optional)'),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add notes about this photo...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryBlue),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: !_hasPhoto || _isLoading ? null : _uploadProof,
                  icon: const Icon(Icons.cloud_upload),
                  label: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          _hasPhoto
                              ? 'Upload Proof Photo'
                              : 'Select a Photo First',
                        ),
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primaryBlue,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'In the full version, photos will be stored securely on the Racitelcom server.',
                        style: TextStyle(
                          color: AppColors.textGray,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    if (!_hasPhoto) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borderColor,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 60,
                color: AppColors.textLight,
              ),
              SizedBox(height: 12),
              Text(
                'No photo selected',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGray,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Tap below to add a photo',
                style: TextStyle(
                  color: AppColors.textGray,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.image,
              size: 60,
              color: AppColors.primaryBlue,
            ),
            SizedBox(height: 12),
            Text(
              'Photo ready to upload',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'proof_photo.jpg',
              style: TextStyle(
                color: AppColors.textGray,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

